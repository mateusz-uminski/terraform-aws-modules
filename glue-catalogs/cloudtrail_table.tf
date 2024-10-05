locals {
  create_cloudtrail_table = var.cloudtrail_bucket_name != "" ? true : false
}

resource "aws_glue_catalog_table" "cloudtrail" {
  count = local.create_cloudtrail_table == true ? 1 : 0

  name          = "${var.org_code}_cloudtrail_glue_table"
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
    name = "date"
    type = "string"
  }

  parameters = {
    "projection.enabled" = "true"

    "projection.account_id.type"   = "enum"
    "projection.account_id.values" = local.account_ids

    "projection.region.type"   = "enum"
    "projection.region.values" = local.regions

    "projection.date.type"          = "date"
    "projection.date.format"        = "yyyy/MM/dd"
    "projection.date.interval"      = "1"
    "projection.date.interval.unit" = "DAYS"
    "projection.date.range"         = "NOW-12MONTHS,NOW"

    "storage.location.template" = "s3://${var.cloudtrail_bucket_name}/AWSLogs/$${account_id}/CloudTrail/$${region}/$${date}"
  }

  storage_descriptor {
    input_format  = "com.amazon.emr.cloudtrail.CloudTrailInputFormat"
    location      = "s3://${var.cloudtrail_bucket_name}/AWSLogs"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hive.hcatalog.data.JsonSerDe"
    }

    columns {
      name = "eventversion"
      type = "string"
    }

    columns {
      name = "useridentity"
      type = "struct<type:string,principalId:string,arn:string,accountId:string,invokedBy:string,accessKeyId:string,userName:string,sessionContext:struct<attributes:struct<mfaAuthenticated:string,creationDate:string>,sessionIssuer:struct<type:string,principalId:string,arn:string,accountId:string,userName:string>>>"
    }

    columns {
      name = "eventtime"
      type = "string"
    }

    columns {
      name = "eventsource"
      type = "string"
    }

    columns {
      name = "eventname"
      type = "string"
    }

    columns {
      name = "awsregion"
      type = "string"
    }

    columns {
      name = "sourceipaddress"
      type = "string"
    }

    columns {
      name = "useragent"
      type = "string"
    }

    columns {
      name = "errorcode"
      type = "string"
    }

    columns {
      name = "errormessage"
      type = "string"
    }

    columns {
      name = "requestparameters"
      type = "string"
    }

    columns {
      name = "responseelements"
      type = "string"
    }

    columns {
      name = "additionaleventdata"
      type = "string"
    }

    columns {
      name = "requestid"
      type = "string"
    }

    columns {
      name = "eventid"
      type = "string"
    }

    columns {
      name = "resources"
      type = "array<struct<arn:string,accountId:string,type:string>>"
    }

    columns {
      name = "eventtype"
      type = "string"
    }

    columns {
      name = "apiversion"
      type = "string"
    }

    columns {
      name = "readonly"
      type = "string"
    }

    columns {
      name = "recipientaccountid"
      type = "string"
    }

    columns {
      name = "serviceeventdetails"
      type = "string"
    }

    columns {
      name = "sharedeventid"
      type = "string"
    }

    columns {
      name = "vpcendpointid"
      type = "string"
    }

    columns {
      name = "tlsdetails"
      type = "struct<tlsVersion:string,cipherSuite:string,clientProvidedHostHeader:string>"
    }
  }
}
