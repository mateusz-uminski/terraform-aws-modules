resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-vpc-${var.env_code}"
  }
}

resource "aws_flow_log" "main" {
  count = var.vpc_flow_logs_s3_bucket_arn != "" ? 1 : 0

  log_destination      = var.vpc_flow_logs_s3_bucket_arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id

  destination_options {
    file_format        = "parquet"
    per_hour_partition = true
  }

  tags = {
    Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-vpc-flow-logs-${var.env_code}"
  }
}
