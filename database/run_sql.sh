#!/bin/bash
set -e

# Usage: run_sql.sh <DbHost> <DbPort> <DbName> <SecretArn>
if [ "$#" -lt 4 ]; then
    echo "Usage: $0 <DbHost> <DbPort> <DbName> <SecretArn>"
    exit 1
fi

DbHost="$1"
DbPort="$2"
DbName="$3"
SecretArn="$4"
echo "DbHost: $DbHost"
echo "DbPort: $DbPort"
echo "DbName: $DbName"
echo "SecretArn: $SecretArn"

# Busca user/senha no Secrets Manager
secret_json=$(aws secretsmanager get-secret-value --region us-east-1 --secret-id "$SecretArn" --query SecretString --output text)
echo $secret_json
user=$(echo "$secret_json" | jq -r .username)
pass=$(echo "$secret_json" | jq -r .password)

# Espera o DB responder
attempts=30
while [ $attempts -gt 0 ]; do
    if mysql --connect-timeout=5 -h "$DbHost" -P "$DbPort" -u "$user" -p"$pass" -e "SELECT 1" "$DbName" >/dev/null 2>&1; then
        break
    else
        sleep 10
        attempts=$((attempts - 1))
        if [ $attempts -le 0 ]; then
            echo "DB não respondeu a tempo." >&2
            exit 1
        fi
    fi
done

mysql --ssl-mode=REQUIRED -h "$DbHost" -P "$DbPort" -u "$user" -p"$pass" "$DbName" -e "source ./sql/1_inicializacao.sql"

echo "Todos os arquivos SQL foram executados."