locals {
  account_ids = join(",", var.account_ids)
  regions     = join(",", var.regions)
}

resource "aws_glue_catalog_database" "main" {
  name = "${var.org_code}-${var.database_name}-glue-db"
}
