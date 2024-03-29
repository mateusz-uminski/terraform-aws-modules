resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  count = var.transit_gateway_id != "" ? 1 : 0

  transit_gateway_id = var.transit_gateway_id

  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private.*.id

  dns_support = "enable"

  ipv6_support           = "disable"
  appliance_mode_support = "disable"

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "${local.org}-${var.vpc_name}-tgw-attachment-${var.vpc_tier}"
  }
}

resource "aws_route" "tgw" {
  count = var.transit_gateway_id != "" ? length(var.private_subnets) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = var.transit_gateway_id
}
