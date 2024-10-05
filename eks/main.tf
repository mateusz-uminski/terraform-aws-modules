locals {
  cluster_name = "${var.org_code}-${var.project_code}-${var.cluster_name}-eks-${var.env_code}"

  base_logging     = ["api", "scheduler", "controllerManager"]
  enhanced_logging = concat(local.base_logging, ["audit", "authenticator"])
  logging_settings = var.enable_enhanced_logging ? local.enhanced_logging : local.base_logging
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "eks" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = var.subnet_names
  }
}

resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 7
}

resource "aws_eks_cluster" "main" {
  name     = local.cluster_name
  role_arn = var.cluster_role_name != "" ? data.aws_iam_role.eks[0].arn : aws_iam_role.eks.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = data.aws_subnets.eks.ids

    endpoint_private_access = var.enable_private_endpoint
    endpoint_public_access  = var.enable_public_endpoint
    public_access_cidrs     = var.endpoint_allowed_cidrs

    security_group_ids = concat([aws_security_group.eks.id], var.additional_security_groups)
  }

  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = var.kubernetes_service_cidr
  }

  enabled_cluster_log_types = local.logging_settings

  depends_on = [aws_iam_role.eks]
}

data "tls_certificate" "eks_oidc_issuer" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc_issuer.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.eks_oidc_issuer.url
}
