# organization

Terraform module that bootstraps an aws organization. It creates organizational
units with given prefixes and attaches a SCP policy to the root.
The SCP policy limits access in the organization only to given regions.
<br>
![](./docs/organization-module.drawio.svg)


# How to use?
1. Import from main branch
```sh
source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//organization"
```
2. Import from a specific branch
```sh
source = git::https://github.com/mateusz-uminski/terraform-aws-modules//organization?ref=branch"
```
3. Import a specific version
```sh
source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//organization?ref=v0.0.1"
```

# Example of usage
```terraform
module "organization" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//organization?ref=main"

  # required variables
  organizational_unit_prefixes   = ["nonprod", "prod"]
  organization_operating_regions = ["us-east-1"]
}
```
