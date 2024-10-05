output "regional_dns_name" {
  value       = trim(aws_vpc_endpoint.main.dns_entry[0].dns_name, "*.")
  description = "The regional DNS name of the endpoint, that resolves to all the available zonal IP addresses associated with the endpoint."
}
