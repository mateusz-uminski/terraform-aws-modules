# tgw-routes

Terraform module for configuring routes within a transit gateway route table.
This module enables attaching the route table to a transit gateway attachment,
propagating routes to specified route tables, defining static routes and blackhole routes.


# Usage
```terraform
module "tgw_routes" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//tgw-routes?ref=main"

  # required variables
  tgw_attachment_id = "tgw-attach-vpc"
  associate_tgw_rt  = "tgw-rtb-12345678901234567"

  # optional variables
  propagate_tgw_rt  = ["tgw-rtb-23456789012345678", "tgw-rtb-34567890123456789"]
  blackholes        = ["10.15.0.0/16"]

  static_routes = [
    { cidr = "10.16.0.0/16", attachment_id = "tgw-attach-vpc" },      # local
    { cidr = "10.17.0.0/16", attachment_id = "tgw-attach-peering" },  # peering
  ]
}
```
