# eks

Terraform module that creates an EKS cluster.

# Usage
```terraform
module "eks_control_plane" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//eks?ref=main"

  # required variables
  org_code     = "org"
  project_code = "infra"
  env_code     = "dev"

  cluster_name        = "main"
  kubernetes_version  = "1.27"
  kubernetes_pod_cidr = "100.64.0.0/16"

  cluster_pod_subnets = ["100.64.0.0/18", "100.64.64.0/18"]

  vpc_name     = "org-main-vpc-dev"
  subnet_names = ["org-main-public-sn1-dev", "org-main-public-sn2-dev"]

  # optional variables
  enable_private_endpoint = true
  enable_public_endpoint  = false
  endpoint_allowed_cidrs  = []
  kubernetes_service_cidr = "172.20.0.0/16"

  cluster_role_name              = ""
  enable_enhanced_logging        = false
  permission_boundary_policy_arn = ""

  additional_security_groups = []
  allowed_ingress_cidrs      = []
  allowed_ingress_sgs        = []
}
```
