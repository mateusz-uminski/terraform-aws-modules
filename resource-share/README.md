# resource-share

Terraform module that shares a specified resource between accounts.


# Example of usage
```terraform
module "ram" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//resource-share?ref=main"

  # required variables
  org_abbreviated_name = "mcd
  name                 = "main-tgw-nonprod"
  resource_arn         = "arn:aws:ec2:us-east-1:123456789012:transit-gateway/tgw-12345678901234567"
  principal            = "234567890123"
}
```
