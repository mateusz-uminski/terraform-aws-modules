output "id" {
  value       = aws_ec2_transit_gateway.main.id
  description = "The ID of the transit gateway."
}

output "arn" {
  value       = aws_ec2_transit_gateway.main.arn
  description = "The ARN of the transit gateway."
}

output "route_table_ids" {
  value       = { for k in var.route_table_names : k => aws_ec2_transit_gateway_route_table.main[k].id }
  description = "The list of transit gateway route table IDs."
}

output "route_table_arns" {
  value       = { for k in var.route_table_names : k => aws_ec2_transit_gateway_route_table.main[k].arn }
  description = "The list of transit gateway route table ARNs."
}
