# ec2

Terraform module that creates a single EC2 instance.

# Example of usage
```terraform
module "ec2" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//ec2?ref=main"

  # required variables
  org_abbreviated_name = "mcd"
  project              = "infra"
  environment          = "dev"

  instance_name    = "public"
  instance_type    = "t2.micro"
  ami_name_pattern = "CentOS-Stream-ec2-9-*"
  key_pair         = "mcd-main-key-pair"

  vpc_name    = "mcd-main-vpc-nonprod"
  subnet_name = "mcd-main-public-sn1-nonprod"

  # optional variables
  assign_public_ip           = true
  instance_profile_name      = ""
  enable_detailed_monitoring = false

  root_ebs_size = 10

  additional_ebs = {
    "ebs1" = {
      size        = 20
      device_name = "/dev/sdb"
      type        = "gp2"
    },
  }

  user_data = <<-EOF
    #! /bin/bash
    touch /helloworld.txt
  EOF

  additional_security_groups = []
  allowed_ingress_cidrs      = []
  allowed_ingress_sgs        = []
}
```
