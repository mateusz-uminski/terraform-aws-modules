output "organizational_units" {
  value = zipmap(
    aws_organizations_organizational_unit.groups[*].name,
    aws_organizations_organizational_unit.groups[*].id
  )
}
