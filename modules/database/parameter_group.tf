resource "aws_db_parameter_group" "mysql_params" {
  name   = "${var.project_name}-mysql-params"
  family = "mysql8.0"

  parameter {
    apply_method = "pending-reboot"
    name         = "tls_version"
    value        = "TLSv1.2"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "sql_mode"
    value        = "STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
  }

  tags = { Name = "${var.project_name}-mysql-params" }
}
