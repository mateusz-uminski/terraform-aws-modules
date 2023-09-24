# rds-postgres

Terraform module that creates a postgres RDS database.

# Example of usage
```terraform
module "rds_postgres" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//rds-postgres?ref=main"

  # required variables
  org_abbreviated_name = "mcd"
  project              = "infra"
  environment          = "dev"

  db_name                = "example"
  db_instance_class      = "db.t4g.micro"
  storage_size           = 20
  db_engine_version      = "15.4"
  parameter_group_family = "postgres15"

  vpc_name     = "mcd-main-vpc-nonprod"
  subnet_names = ["mcd-main-public-sn1-nonprod", "mcd-main-public-sn2-nonprod"]

  # optional variables
  db_port       = 5432
  is_mutli_az   = true
  is_public     = false
  db_username   = "cloudadmin"
  db_password   = "cloudadmin"
  ca_identifier = "rds-ca-rsa2048-g1"

  number_of_standby_instances     = 0
  enable_enhanced_monitoring      = false
  enable_performance_insights     = false
  permissions_boundary_policy_arn = ""

  parameters                 = []
  additional_security_groups = []
  allowed_ingress_cidrs      = []
  allowed_ingress_sgs        = []
}
```
