data "aws_ec2_transit_gateway_route_tables" "association" {
  filter {
    name   = "tag:Name"
    values = [var.associate_tgw_rt]
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "main" {
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_tables.association.ids[0]
  transit_gateway_attachment_id  = var.tgw_attachment_id
}

data "aws_ec2_transit_gateway_route_tables" "propagation" {
  filter {
    name   = "tag:Name"
    values = var.propagate_tgw_rt
  }
}

resource "aws_ec2_transit_gateway_route_table_propagation" "main" {
  for_each = toset(data.aws_ec2_transit_gateway_route_tables.propagation.ids)

  transit_gateway_route_table_id = each.key
  transit_gateway_attachment_id  = var.tgw_attachment_id
}

resource "aws_ec2_transit_gateway_route" "static" {
  for_each = { for i, v in var.static_routes : "${v.cidr}" => v }

  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_tables.association.ids[0]
  destination_cidr_block         = each.value.cidr
  transit_gateway_attachment_id  = each.value.attachment_id
}

resource "aws_ec2_transit_gateway_route" "blackhole" {
  for_each = toset(var.blackholes)

  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_tables.association.ids[0]
  destination_cidr_block         = each.key
  blackhole                      = true
}
