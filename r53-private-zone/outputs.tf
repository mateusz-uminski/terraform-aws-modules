output "zone_id" {
  value       = aws_route53_zone.private.id
  description = "The ID of the private hosted zone."
}
