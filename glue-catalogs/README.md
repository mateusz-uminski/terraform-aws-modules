# glue-catalogs

Terraform module that creates Glue tables for AWS service logs, such as CloudTrail logs. The module provides a centralized location for searching and analyzing logs across multiple accounts.

To optimize querying performance and reduce costs, the Glue tables created by this module are configured with partition projections based on the specified `account_ids` and `regions`. Additionally, all tables have a timestamp range projection set to `NOW-12MONTHS,NOW`, limiting the amount of data scanned by Athena queries to the last 12 months.

sources:
- [querying-aws-service-logs](https://docs.aws.amazon.com/athena/latest/ug/querying-aws-service-logs.html)
- [partition-projection](https://docs.aws.amazon.com/athena/latest/ug/partition-projection-supported-types.html)

# Usage
```terraform
module "aws_service_logs" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//glue-catalogs?ref=main"

  # required variables
  org_code      = "org"
  database_name = "aws-service-logs"
  account_ids   = ["123456789012", "234567890123"]
  regions       = ["us-east-1", "eu-west-1"]

  # optional variables
  cloudtrail_bucket_name    = "org-cloudtrail-bucket"
  vpc_flow_logs_bucket_name = "org-vpc-flow-logs-bucket"
}
```

# Example athena queries
```sql
-- cloudtrail
select * from org_cloudtrail_glue_table where account_id = '111111111111' and region = 'us-east-1' and "date" = '2023/07/03' limit 10;

-- vpc flow logs
select * from org_vpc_flow_logs_glue_table where account_id = '111111111111' and region in ('us-east-1', 'eu-west-1') and "timestamp" > '2023/07/01' limit 10;
select * from org_vpc_flow_logs_glue_table where account_id = '111111111111' and region in ('us-east-1', 'eu-west-1') and "timestamp" > '2023/07/01/10' and "timestamp" < '2023/07/01/20' limit 10;
```
