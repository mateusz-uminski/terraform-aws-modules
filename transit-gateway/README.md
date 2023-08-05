# transit-gateway

Terraform module that creates a transit gateway and transit gateway route tables.

# Example of usage
```terraform
module "transit_gateway" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//transit-gateway?ref=main"

  # required variables
  org_abbreviated_name = var.org_abbreviated_name
  name                 = "main"
  asn                  = "65000"
  route_table_names    = ["shared", "nonprod", "prod"]
}
```
