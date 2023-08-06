output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the vpc."
}

output "tgw_attachment_id" {
  value       = var.transit_gateway_id != "" ? aws_ec2_transit_gateway_vpc_attachment.main[0].id : ""
  description = "The ID of the attached transit gateway to the vpc."
}
