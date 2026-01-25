resource "random_password" "master" {
  length  = 20
  special = false
}

resource "aws_secretsmanager_secret" "db_master" {
  name        = "${var.project_name}-${var.idSecret}/rds-mysql/master"
  description = "Master credentials for ${var.project_name} RDS MySQL"
  kms_key_id  = var.kms_key_id
}

resource "aws_secretsmanager_secret_version" "db_master_val" {
  secret_id = aws_secretsmanager_secret.db_master.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.master.result
  })
}

resource "aws_db_instance" "mysql" {
  identifier     = "${var.project_name}-mysql"
  engine         = "mysql"
  engine_version = var.db_engine_version == null ? null : var.db_engine_version

  instance_class = var.instance_class
  username       = var.db_username
  password       = jsondecode(aws_secretsmanager_secret_version.db_master_val.secret_string).password
  db_name        = var.db_name

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  storage_encrypted = true
  kms_key_id        = var.kms_key_id

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_mysql.id]

  publicly_accessible = true
  multi_az            = var.multi_az

  backup_retention_period    = var.backup_retention_period
  deletion_protection        = var.deletion_protection
  copy_tags_to_snapshot      = true
  auto_minor_version_upgrade = true
  apply_immediately          = false

  monitoring_interval                 = var.enable_enhanced_monitoring ? var.monitoring_interval : 0
  parameter_group_name                = aws_db_parameter_group.mysql_params.name
  iam_database_authentication_enabled = var.enable_iam_auth

  tags = { Name = "${var.project_name}-mysql" }

  skip_final_snapshot = true
}

locals {
  init_host = var.override_init_host != null ? var.override_init_host : aws_db_instance.mysql.address
  init_port = var.override_init_port != null ? var.override_init_port : 3306
}

resource "null_resource" "db_init_sql" {
  count = var.run_db_init ? 1 : 0

  triggers = {
    db_endpoint = aws_db_instance.mysql.endpoint
    files_list  = join(" ", formatlist("${path.module}/init/sql/%s", var.init_sql_paths))
    init_host   = local.init_host
    init_port   = tostring(local.init_port)
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    working_dir = "${path.module}/init"
    command     = <<-BASH
      ./run_sql.sh "${local.init_host}" ${local.init_port} "${var.db_name}" "${aws_secretsmanager_secret.db_master.arn}" 
      BASH
  }

  depends_on = [
    aws_db_instance.mysql,
    aws_secretsmanager_secret_version.db_master_val
  ]
}

output "db_endpoint" { value = aws_db_instance.mysql.endpoint }
output "db_address" { value = aws_db_instance.mysql.address }
output "db_port" { value = 3306 }
output "secrets_manager_arn" { value = aws_secretsmanager_secret.db_master.arn }
