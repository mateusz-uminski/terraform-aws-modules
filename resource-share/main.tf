resource "aws_ram_resource_share" "main" {
  name                      = "${var.org_code}-${var.name}-ram"
  allow_external_principals = true
}

resource "aws_ram_resource_association" "main" {
  resource_share_arn = aws_ram_resource_share.main.arn
  resource_arn       = var.resource_arn
}

resource "aws_ram_principal_association" "invite" {
  resource_share_arn = aws_ram_resource_share.main.arn
  principal          = var.principal
}
