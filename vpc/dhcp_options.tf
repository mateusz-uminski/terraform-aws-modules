resource "aws_vpc_dhcp_options" "main" {
  count = var.domain_name != "" ? 1 : 0

  domain_name         = var.domain_name
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = merge(
    {
      Name = "${var.org_code}-${var.project_code}-${var.vpc_name}-dhcp-opts-${var.env_code}"
    },
    var.tags
  )
}

resource "aws_vpc_dhcp_options_association" "main" {
  count = var.domain_name != "" ? 1 : 0

  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main[0].id
}
