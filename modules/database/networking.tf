data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-rds-subnets"
  subnet_ids = var.private_subnet_ids

  tags = { Name = "${var.project_name}-rds-subnets" }
}

resource "aws_security_group" "rds_mysql" {
  name        = "${var.project_name}-rds-sg"
  description = "MySQL access SG"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "MySQL from allowed CIDR"
    }
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "MySQL/Aurora IPv4 open access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-rds-sg" }
}

//resource "aws_security_group_rule" "allow_app_sg_to_rds" {
//  for_each                 = toset(var.app_security_group_ids)
//  type                     = "ingress"
//  from_port                = 3306
//  to_port                  = 3306
//  protocol                 = "tcp"
//  security_group_id        = aws_security_group.rds_mysql.id
//  source_security_group_id = each.value
//  description              = "Allow App SG (${each.value}) to access MySQL 3306"
//}
