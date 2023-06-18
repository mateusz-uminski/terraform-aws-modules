resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${local.org}-${var.vpc_name}-vpc-${var.vpc_tier}"
  }
}

resource "aws_s3_bucket" "flow_logs" {
  count = var.vpc_flow_logs == true ? 1 : 0

  bucket = "${local.org}-${var.vpc_name}-vpc-${var.vpc_tier}-flow-logs"
}


resource "aws_flow_log" "main" {
  count = var.vpc_flow_logs == true ? 1 : 0

  log_destination      = aws_s3_bucket.flow_logs[0].arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id

  destination_options {
    file_format        = "parquet"
    per_hour_partition = true
  }

  tags = {
    Name = "${local.org}-${var.vpc_name}-vpc-${var.vpc_tier}"
  }
}
