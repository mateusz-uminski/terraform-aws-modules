resource "aws_route53_zone" "private" {
  name = var.zone_name

  dynamic "vpc" {
    for_each = var.vpcs
    iterator = i

    content {
      vpc_id     = i.value.vpc_id
      vpc_region = i.value.region
    }
  }

  # allow managing additional associations
  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_vpc_association_authorization" "private" {
  for_each = var.external_vpcs

  zone_id    = aws_route53_zone.private.id
  vpc_id     = each.value.vpc_id
  vpc_region = each.value.region
}
