locals {
  create_vpc_flow_logs_table = var.vpc_flow_logs_bucket_name != "" ? true : false
}

resource "aws_glue_catalog_table" "vpc_flow_logs" {
  count = local.create_vpc_flow_logs_table == true ? 1 : 0

  name          = "${var.org_code}_vpc_flow_logs_glue_table"
  database_name = aws_glue_catalog_database.main.name

  table_type = "EXTERNAL_TABLE"

  partition_keys {
    name = "account_id"
    type = "string"
  }

  partition_keys {
    name = "region"
    type = "string"
  }

  partition_keys {
    name = "timestamp"
    type = "string"
  }

  parameters = {
    "skip.header.line.count" = "1"

    "projection.enabled" = "true"

    "projection.account_id.type"   = "enum"
    "projection.account_id.values" = local.account_ids

    "projection.region.type"   = "enum"
    "projection.region.values" = local.regions

    "projection.timestamp.type"          = "date"
    "projection.timestamp.format"        = "yyyy/MM/dd/HH"
    "projection.timestamp.interval"      = "1"
    "projection.timestamp.interval.unit" = "HOURS"
    "projection.timestamp.range"         = "NOW-12MONTHS,NOW"

    "storage.location.template" = "s3://${var.vpc_flow_logs_bucket_name}/AWSLogs/$${account_id}/vpcflowlogs/$${region}/$${timestamp}"
  }

  storage_descriptor {
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    location      = "s3://${var.vpc_flow_logs_bucket_name}/AWSLogs"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    columns {
      name = "version"
      type = "int"
    }

    columns {
      name = "interface_id"
      type = "string"
    }

    columns {
      name = "srcaddr"
      type = "string"
    }

    columns {
      name = "dstaddr"
      type = "string"
    }

    columns {
      name = "srcport"
      type = "int"
    }

    columns {
      name = "dstport"
      type = "int"
    }

    columns {
      name = "protocol"
      type = "bigint"
    }

    columns {
      name = "packets"
      type = "bigint"
    }

    columns {
      name = "bytes"
      type = "bigint"
    }

    columns {
      name = "start"
      type = "bigint"
    }

    columns {
      name = "`end`"
      type = "bigint"
    }

    columns {
      name = "action"
      type = "string"
    }

    columns {
      name = "log_status"
      type = "string"
    }

    columns {
      name = "vpc_id"
      type = "string"
    }

    columns {
      name = "subnet_id"
      type = "string"
    }

    columns {
      name = "instance_id"
      type = "string"
    }

    columns {
      name = "tcp_flags"
      type = "int"
    }

    columns {
      name = "type"
      type = "string"
    }

    columns {
      name = "pkt_srcaddr"
      type = "string"
    }

    columns {
      name = "pkt_dstaddr"
      type = "string"
    }

    columns {
      name = "az_id"
      type = "string"
    }

    columns {
      name = "sublocation_type"
      type = "string"
    }

    columns {
      name = "sublocation_id"
      type = "string"
    }

    columns {
      name = "pkt_src_aws_service"
      type = "string"
    }

    columns {
      name = "pkt_dst_aws_service"
      type = "string"
    }

    columns {
      name = "flow_direction"
      type = "string"
    }

    columns {
      name = "traffic_path"
      type = "int"
    }
  }
}
