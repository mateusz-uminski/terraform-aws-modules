locals {
  db_name   = "${var.org_code}-${var.project_code}-${var.db_name}-${local.db_engine}-rds-${var.env_code}"
  db_engine = "psql"
}

data "aws_subnets" "main" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = var.subnet_names
  }
}

resource "aws_db_subnet_group" "main" {
  name        = "${var.org_code}-${var.project_code}-${var.db_name}-db-sn-grp-${var.env_code}"
  description = "Subnet group for ${local.db_name} rds database."
  subnet_ids  = data.aws_subnets.main.ids
}

resource "aws_db_parameter_group" "main" {
  name        = "${var.org_code}-${var.project_code}-${var.db_name}-db-param-grp-${var.env_code}"
  description = "Parameter group for ${local.db_name} rds database."
  family      = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.parameters
    iterator = i

    content {
      name  = i.value.name
      value = i.value.value
    }
  }
}

data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/rds/instance/${local.db_name}/postgresql"
  retention_in_days = 7
}

resource "aws_iam_role" "enhanced_monitoring" {
  name        = "${var.org_code}-${var.project_code}-${var.db_name}-enhanced-monitoring-role-${var.env_code}"
  description = "Subnet group for ${local.db_name} database that enables enhanced monitoring."

  assume_role_policy = data.aws_iam_policy_document.trust_policy.json

  permissions_boundary = var.permissions_boundary_policy_arn

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"]
}

resource "aws_db_instance" "main" {
  identifier            = local.db_name
  instance_class        = var.db_instance_class
  allocated_storage     = var.storage_size
  max_allocated_storage = var.storage_size + 5

  multi_az             = var.is_mutli_az
  publicly_accessible  = var.is_public
  db_subnet_group_name = aws_db_subnet_group.main.id

  engine               = "postgres"
  engine_version       = var.db_engine_version
  parameter_group_name = aws_db_parameter_group.main.id

  username = var.db_username
  password = var.db_password

  performance_insights_enabled = var.enable_performance_insights
  monitoring_role_arn          = var.enable_enhanced_monitoring ? aws_iam_role.enhanced_monitoring.arn : ""
  monitoring_interval          = var.enable_enhanced_monitoring ? 1 : 0

  port                   = var.db_port
  vpc_security_group_ids = [aws_security_group.main.id]

  apply_immediately               = true
  skip_final_snapshot             = true
  backup_retention_period         = 1    #
  delete_automated_backups        = true #
  auto_minor_version_upgrade      = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  depends_on = [aws_cloudwatch_log_group.main]
}

resource "aws_cloudwatch_log_group" "standby" {
  count = var.number_of_standby_instances

  name              = "/aws/rds/instance/${var.org_code}-${var.project_code}-${var.db_name}-${local.db_engine}-rds-standby${count.index}-${var.env_code}/postgresql"
  retention_in_days = 7
}

resource "aws_db_instance" "standby" {
  count = var.number_of_standby_instances

  identifier          = "${var.org_code}-${var.project_code}-${var.db_name}-${local.db_engine}-rds-standby${count.index}-${var.env_code}"
  replicate_source_db = aws_db_instance.main.identifier

  instance_class = var.db_instance_class

  multi_az            = var.is_mutli_az
  publicly_accessible = var.is_public

  performance_insights_enabled = var.enable_performance_insights
  monitoring_role_arn          = var.enable_enhanced_monitoring ? aws_iam_role.enhanced_monitoring.arn : ""
  monitoring_interval          = var.enable_enhanced_monitoring ? 1 : 0

  apply_immediately               = true
  skip_final_snapshot             = true
  auto_minor_version_upgrade      = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  depends_on = [aws_cloudwatch_log_group.standby]
}
