output "internal_lb_ip_address" {
  value = module.alb_internal.internal_lb_ip_address
}

output "public_ip_external_alb" {
  value = module.alb_external.public_ip_external_alb
}
