# asg

Terraform module that creates an autoscaling group of ec2 instances.

# Usage
```terraform
module "asg" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//asg?ref=main"

  # required variables
  org_code     = "org"
  project_code = "infra"
  env_code     = "dev"

  asg_name     = "centos"
  asg_capacity = 3

  instance_type    = "t2.micro"
  ami_name_pattern = "CentOS-Stream-ec2-9-*"
  key_pair         = "org-main-key-pair"

  vpc_name     = "org-main-vpc-nonprod"
  subnet_names = ["org-main-public-sn1-nonprod"]

  # optional variables
  placement_group            = "partition"
  assign_public_ip           = false
  instance_profile_name      = ""
  enable_detailed_monitoring = false

  root_ebs = {
    device_name = "/dev/sda1"
    size        = 20
  }

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

  exposed_port = 80
  protocol     = "HTTP"
}
```
