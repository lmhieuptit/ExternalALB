output "internal_lb_ip_address-asia-northeast1" {
  value = module.alb_internal-asia-northeast1.internal_lb_ip_address
}

# output "internal_lb_ip_address-asia-northeast2" {
#   value = module.alb_internal-asia-northeast2.internal_lb_ip_address
# }

output "public_ip_external_alb" {
  value = module.alb_external.public_ip_external_alb
}
