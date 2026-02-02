resource "aws_db_parameter_group" "mysql_params" {
  name   = "${var.projectName}-mysql-params"
  family = "mysql8.4"

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

  tags = { Name = "${var.projectName}-mysql-params" }
}
