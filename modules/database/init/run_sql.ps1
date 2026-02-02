Param(
  [Parameter(Mandatory = $true)][string]$DbHost,
  [Parameter(Mandatory = $true)][int]   $DbPort,
  [Parameter(Mandatory = $true)][string]$DbName,
  [Parameter(Mandatory = $true)][string]$SecretArn,
  [Parameter(Mandatory = $true)][string]$FilesList,
  [string]$MysqlPath
)
$ErrorActionPreference = "Stop"

function Find-MySqlExe {
  param([string]$Hint)

  # 1) Se passou caminho explicitamente
  if ($Hint -and (Test-Path -LiteralPath $Hint)) { return $Hint }

  # 2) Tenta via PATH (compatível com PS 5.1 – sem '?.')
  $cmd = $null
  try { $cmd = Get-Command mysql -ErrorAction SilentlyContinue } catch {}
  if ($cmd -and $cmd.Source -and (Test-Path -LiteralPath $cmd.Source)) { return $cmd.Source }

  # 3) Locais comuns
  $candidates = @(
    "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
    "C:\Program Files\MySQL\MySQL Workbench 8.0 CE\mysql.exe",
    "C:\Program Files\MySQL\MySQL Shell 8.0\bin\mysql.exe",
    "C:\MySQL\bin\mysql.exe"
  )
  foreach ($c in $candidates) { if (Test-Path -LiteralPath $c) { return $c } }

  # 4) Varredura leve em pastas padrão (se existirem)
  $roots = @("C:\Program Files\MySQL","C:\Program Files (x86)\MySQL","C:\MySQL")
  foreach ($r in $roots) {
    if (Test-Path -LiteralPath $r) {
      $found = Get-ChildItem -Path $r -Recurse -Filter mysql.exe -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
      if ($found) { return $found }
    }
  }

  throw "mysql client não encontrado. Instale o cliente ou informe -MysqlPath 'C:\...\mysql.exe'."
}

# Resolve caminho do mysql.exe
#$MYSQL = Find-MySqlExe -Hint $MysqlPath
$MYSQL = "mysql" 

# Busca user/senha no Secrets Manager
$secretJson = aws secretsmanager get-secret-value --region us-east-1 --secret-id $SecretArn --query SecretString --output text
$secret = $secretJson | ConvertFrom-Json
$user = $secret.username
$pass = $secret.password

# Espera o DB responder
$attempts = 30
while ($attempts -gt 0) {
  try {
    & $MYSQL --connect-timeout=5 -h $DbHost -P $DbPort -u $user "-p$pass" -e "SELECT 1" | Out-Null
    break
  } catch {
    Start-Sleep -Seconds 10
    $attempts -= 1
    if ($attempts -le 0) { throw "DB não respondeu a tempo." }
  }
}

# Normaliza lista de arquivos (aceita caminhos absolutos ou relativos)
function Resolve-SqlPath {
  param([string]$p)
  if ([System.IO.Path]::IsPathRooted($p)) {
    return $p
  } else {
    # tenta relativo ao diretório atual e ao diretório do script
    try {
      $rp = Resolve-Path -LiteralPath $p -ErrorAction Stop
      return $rp.Path
    } catch {
      $base = Split-Path -Parent $MyInvocation.MyCommand.Path
      $try2 = Join-Path -Path $base -ChildPath $p
      if (Test-Path -LiteralPath $try2) { return (Resolve-Path -LiteralPath $try2).Path }
      return $p # deixa como veio; o mysql vai reportar se não existir
    }
  }
}

$files = @()
foreach ($f in ($FilesList -split "\s+")) {
  if ($f -and $f.Trim() -ne "") { $files += (Resolve-SqlPath -p $f) }
}

foreach ($f in $files) {
  Write-Host "Executando $f ..."
  & $MYSQL --ssl-mode=REQUIRED -h $DbHost -P $DbPort -u $user "-p$pass" $DbName -e ("source " + $f)
}
Write-Host "Todos os arquivos SQL foram executados."
