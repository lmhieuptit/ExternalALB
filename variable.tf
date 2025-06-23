variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}
variable "region_primary" {
  description = "The region where resources will be created"
  type        = string
}

variable "region_secondary" {
  description = "The region where resources will be created"
  type        = string
}

//------------------------------------------VPC Network----------------------------------------------------------------//
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "vpc_subnets" {
  description = "A map of subnets to create"
  type = map(object({
    name                     = string
    cidr                     = string
    region                   = string
    private_ip_google_access = bool
  }))
}

variable "vpc_subnets_proxy" {
  type = map(object({
    proxy_only_subnet_name = string
    proxy_only_subnet_cidr = string
    region                 = string
  }))
}
/* Firewall Rules */
variable "public_subnet_web_tag" {
  description = "Tag subnet public web"
  type        = string
}

variable "private_subnet_app_tag" {
  description = "Tag subnet private app"
  type        = string
}

variable "private_subnet_database_tag" {
  description = "Tag subnet private database"
  type        = string
}

variable "private_subnet_direct_to_vpc_tag" {
  type = string
}

//------------------------------------------Network Services---------------------------------------------------------------//
/*Cloud DNS*/
variable "cloud_dns_name" {
  type = string
}

variable "cloud_dns_dns_name" {
  type = string
}

variable "google_dns_record_set_name" {
  type = string
}

//-----------------------------------------------------------Internal ALB---------------------------------------//

variable "internal_cloud_run_neg_app" {
  type = map(object({
    name         = string
    service_name = string
    region       = string
  }))
}

variable "internal_load_balancer_name_app" {
  description = "The name of the load balancer"
  type        = string
}

variable "internal_load_balancing_scheme_app" {
  type = string
}

variable "internal_url_map_default_service_key" {
  description = "The key (from internal_cloud_run_neg_app) for the default backend service for the URL map."
  type        = string
}

variable "internal_url_map_host_rules" {
  description = "A list of host rules for the URL map."
  type = list(object({
    hosts        = list(string)
    path_matcher = string
  }))
  default = []
}

variable "internal_url_map_path_matchers" {
  description = "A list of path matchers for the URL map."
  type = list(object({
    name                = string
    default_service_key = string
    path_rules = list(object({
      paths       = list(string)
      service_key = string
      route_action = optional(object({
        url_rewrite = optional(object({
          path_prefix_rewrite = optional(string)
          host_rewrite        = optional(string)
        }))
      }))
    }))
  }))
  default = []
}

//------------------------------------------------------------------External ALB---------------------------------------//
variable "external_cloud_run_neg_web" {
  type = map(object({
    name         = string
    service_name = string
    region       = string
  }))
}
variable "external_backend_services_config" {
  description = "Configuration for global backend services, mapping a logical service to its NEGs."
  type = map(object({
    port_name = string
    backends = list(object({
      neg_key         = string
      capacity_scaler = optional(number, 1.0)
    }))
  }))
}

variable "external_load_balancer_name_web" {
  description = "The name of the load balancer"
  type        = string
}

variable "external_load_balancing_scheme_web" {
  type = string
}

variable "external_url_map_default_service_key" {
  description = "The key (from internal_cloud_run_neg_app) for the default backend service for the URL map."
  type        = string
}

variable "external_url_map_host_rules" {
  description = "A list of host rules for the URL map."
  type = list(object({
    hosts        = list(string)
    path_matcher = string
  }))
  default = []
}

variable "external_url_map_path_matchers" {
  description = "A list of path matchers for the URL map."
  type = list(object({
    name                = string
    default_service_key = string
    path_rules = list(object({
      paths       = list(string)
      service_key = string
      route_action = optional(object({
        url_rewrite = optional(object({
          path_prefix_rewrite = optional(string)
          host_rewrite        = optional(string)
        }))
      }))
    }))
  }))
  default = []
}



//----------------------------------------------Cloud Run-------------------------------------------------------------------//
variable "cloud_run_services" {
  description = "A map of Cloud Run services to create"
  type = map(object({
    name             = string
    container_name   = string
    docker_image     = string
    region           = string
    minScale         = string
    maxScale         = string
    ingress          = string
    port             = string
    env              = optional(map(string))
    command          = optional(list(string))
    args             = optional(list(string))
    vpc_network      = optional(string)
    vpc_subnetwork   = optional(string)
    vpc_network_tags = optional(list(string))
    vpc_egress       = optional(string)
  }))
}

//--------------------------------------------------Compute Engine--------------------------------------------------------------//
variable "zone" {
  description = "The zone where the instance will be created"
  type        = string
}

variable "instance_name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "image" {
  type = string
}
