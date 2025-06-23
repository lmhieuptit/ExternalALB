module "alb_internal-asia-northeast1" {
  source                               = "./alb_internal"
  region                               = var.region_primary
  internal_cloud_run_neg_app           = var.internal_cloud_run_neg_app
  internal_lb_subnet_self_link         = var.internal_lb_subnet_self_link
  internal_load_balancer_name_app      = var.internal_load_balancer_name_app
  internal_load_balancing_scheme_app   = var.internal_load_balancing_scheme_app
  vpc_network_self_link                = var.vpc_network_self_link
  internal_url_map_default_service_key = var.internal_url_map_default_service_key
  internal_url_map_host_rules          = var.internal_url_map_host_rules
  internal_url_map_path_matchers       = var.internal_url_map_path_matchers
}

# module "alb_internal-asia-northeast2" {
#   source                               = "./alb_internal"
#   region                               = var.region_secondary
#   internal_cloud_run_neg_app           = var.internal_cloud_run_neg_app
#   internal_lb_subnet_self_link         = var.internal_lb_subnet_self_link
#   internal_load_balancer_name_app      = var.internal_load_balancer_name_app
#   internal_load_balancing_scheme_app   = var.internal_load_balancing_scheme_app
#   vpc_network_self_link                = var.vpc_network_self_link
#   internal_url_map_default_service_key = var.internal_url_map_default_service_key
#   internal_url_map_host_rules          = var.internal_url_map_host_rules
#   internal_url_map_path_matchers       = var.internal_url_map_path_matchers
# }

module "alb_external" {
  source                               = "./alb_external"
  external_cloud_run_neg_web           = var.external_cloud_run_neg_web
  external_backend_services_config     = var.external_backend_services_config
  external_load_balancer_name_web      = var.external_load_balancer_name_web
  external_load_balancing_scheme_web   = var.external_load_balancing_scheme_web
  external_url_map_default_service_key = var.external_url_map_default_service_key
  external_url_map_host_rules          = var.external_url_map_host_rules
  external_url_map_path_matchers       = var.external_url_map_path_matchers
}
