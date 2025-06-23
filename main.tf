provider "google" {
  project = var.project_id
}

module "vpc" {
  source            = "./modules/Networking/vpc_network/vpc"
  vpc_name          = var.vpc_name
  vpc_subnets       = var.vpc_subnets
  vpc_subnets_proxy = var.vpc_subnets_proxy
}

module "firewall" {
  depends_on                       = [module.vpc]
  source                           = "./modules/Networking/vpc_network/firewall"

  vpc_name                         = var.vpc_name
  public_subnet_web_tag            = var.public_subnet_web_tag
  private_subnet_app_tag           = var.private_subnet_app_tag
  private_subnet_database_tag      = var.private_subnet_database_tag
  private_subnet_direct_to_vpc_tag = var.private_subnet_direct_to_vpc_tag
}

module "cloud_run" {
  depends_on         = [module.vpc, module.firewall]
  source             = "./modules/Serverless/cloud_run"

  cloud_run_services = var.cloud_run_services
}

module "load_balancing" {
  depends_on                           = [module.vpc, module.firewall, module.cloud_run]
  source                               = "./modules/Networking/network_services/load_balancing"
  region_primary                       = var.region_primary
  region_secondary                     = var.region_secondary

  internal_cloud_run_neg_app           = var.internal_cloud_run_neg_app
  internal_lb_subnet_self_link         = module.vpc.private_subnet_app_self_link
  internal_load_balancer_name_app      = var.internal_load_balancer_name_app
  internal_load_balancing_scheme_app   = var.internal_load_balancing_scheme_app
  vpc_network_self_link                = module.vpc.vpc_network_self_link
  internal_url_map_default_service_key = var.internal_url_map_default_service_key
  internal_url_map_host_rules          = var.internal_url_map_host_rules
  internal_url_map_path_matchers       = var.internal_url_map_path_matchers

  external_cloud_run_neg_web           = var.external_cloud_run_neg_web
  external_backend_services_config     = var.external_backend_services_config
  external_load_balancer_name_web      = var.external_load_balancer_name_web
  external_load_balancing_scheme_web   = var.external_load_balancing_scheme_web
  external_url_map_default_service_key = var.external_url_map_default_service_key
  external_url_map_host_rules          = var.external_url_map_host_rules
  external_url_map_path_matchers       = var.external_url_map_path_matchers
}

# module "cloud_dns" {
#   depends_on                    = [module.load_balancing]
#   source                        = "./modules/Networking/network_services/cloud_dns"

#   vpc_network_self_link         = module.vpc.vpc_network_self_link
#   cloud_dns_name                = var.cloud_dns_name
#   cloud_dns_dns_name            = var.cloud_dns_dns_name
#   google_dns_record_set_name    = var.google_dns_record_set_name
#   google_dns_record_set_rrdatas = module.load_balancing.internal_lb_ip_address-asia-northeast1
# }

# module "compute_engine" {
#   depends_on            = [module.vpc]
#   source                = "./modules/Compute/compute_engine"
#   zone                  = var.zone
#   image                 = var.image
#   instance_name         = var.instance_name
#   machine_type          = var.machine_type
#   network_tags          = [var.private_subnet_direct_to_vpc_tag]
#   vpc_network_self_link = module.vpc.vpc_network_self_link
#   subnetwork_self_link  = module.vpc.subnets_self_links["private-subnet-app-${var.region_primary}"]
# }

# Gọi module Cloud Build
