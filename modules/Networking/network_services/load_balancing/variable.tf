variable "region_primary" {
  description = "The region where resources will be created"
  type        = string
}

variable "region_secondary" {
  description = "The region where resources will be created"
  type        = string
}
//-----------------------------------------------------------Internal ALB---------------------------------------//
variable "vpc_network_self_link" {
  type = string
}
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
  description = "The name of the load balancer"
  type = string
}


variable "internal_lb_subnet_self_link" {
  description = "The self-link of the subnet where the internal LB IP address should reside."
  type        = string
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

