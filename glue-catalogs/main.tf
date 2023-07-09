locals {
  org = var.org_abbreviated_name

  account_ids = join(",", var.account_ids)
  regions     = join(",", var.regions)
}

resource "aws_glue_catalog_database" "main" {
  name = "${local.org}-${var.database_name}-glue-db"
}
