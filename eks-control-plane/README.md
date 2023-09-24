# eks-control-plane

Terraform module that creates an EKS cluster.

List of modules used for EKS configuration:
- [eks-control-plane](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/eks-control-plane)
- [eks-node-group](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/eks-node-group)
- [eks-addons](https://github.com/mateusz-uminski/terraform-aws-modules/tree/main/eks-addons)

# Example of usage
```terraform
module "eks_control_plane" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//eks-control-plane?ref=main"

  # required variables
  org_abbreviated_name = "mcd"
  project              = "infra"

  cluster_name        = "main"
  cluster_tier        = "nonprod"
  kubernetes_version  = "1.27"
  kubernetes_pod_cidr = "100.64.0.0/16"

  cluster_pod_subnets = ["100.64.0.0/18", "100.64.64.0/18"]

  vpc_name     = "mcd-main-vpc-nonprod"
  subnet_names = ["mcd-main-public-sn1-nonprod", "mcd-main-public-sn2-nonprod"]

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
