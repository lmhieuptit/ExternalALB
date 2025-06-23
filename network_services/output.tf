output "dns_name_internal_alb" {
  value = module.cloud_dns.dns_name_internal_alb
}

output "public_ip_external_alb" {
  value = module.load_balancing.public_ip_external_alb
}
