resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = var.kubernetes_pod_cidr
}

resource "aws_subnet" "pod" {
  count = length(var.cluster_pod_subnets)

  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = var.cluster_pod_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.org_code}-${var.cluster_name}-eks-sn${count.index + 1}-${var.env_code}"

    "net:tier"         = "private"
    "eks:cluster-name" = local.cluster_name
  }

  depends_on = [aws_vpc_ipv4_cidr_block_association.secondary_cidr]
}
