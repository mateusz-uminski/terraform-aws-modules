resource "aws_ec2_transit_gateway" "main" {
  amazon_side_asn = var.asn

  dns_support                    = "enable"
  auto_accept_shared_attachments = "enable"

  vpn_ecmp_support                = "disable"
  multicast_support               = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "${var.org_code}-${var.name}-tgw"
  }
}

resource "aws_ec2_transit_gateway_route_table" "main" {
  for_each = toset(var.route_table_names)

  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = {
    Name = "${var.org_code}-${each.key}-tgw-rt"
  }
}
