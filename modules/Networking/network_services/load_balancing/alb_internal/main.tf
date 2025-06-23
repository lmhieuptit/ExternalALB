resource "google_compute_region_network_endpoint_group" "cloudrun_neg_app" {
  for_each = { for k, v in var.internal_cloud_run_neg_app : k => v if v.region == var.region }

  name                  = each.value.name
  network_endpoint_type = "SERVERLESS"
  region                = each.value.region
  cloud_run {
    service = each.value.service_name
  }
}

resource "google_compute_address" "internal_ip" {
  name         = "my-internal-static-ip"
  region       = var.region
  subnetwork   = var.internal_lb_subnet_self_link
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
}

resource "google_compute_region_backend_service" "cloudrun_backends" {
  for_each = google_compute_region_network_endpoint_group.cloudrun_neg_app

  name        = "${each.key}-backend"
  region      = each.value.region
  port_name   = "http"
  timeout_sec = 30

  load_balancing_scheme = var.internal_load_balancing_scheme_app
  backend {
    group          = each.value.id
    description    = "Backend NEG for ${each.value.name}"
    balancing_mode = "UTILIZATION"
  }

  enable_cdn = false
  lifecycle {
    ignore_changes        = [region]
    create_before_destroy = true
  }
}

resource "google_compute_region_url_map" "url_map" {
  name            = var.internal_load_balancer_name_app
  region          = var.region
  default_service = google_compute_region_backend_service.cloudrun_backends[var.internal_url_map_default_service_key].id

  dynamic "host_rule" {
    for_each = var.internal_url_map_host_rules
    content {
      hosts        = host_rule.value.hosts
      path_matcher = host_rule.value.path_matcher
    }
  }

  dynamic "path_matcher" {
    for_each = { for pm in var.internal_url_map_path_matchers : pm.name => pm }
    content {
      name            = path_matcher.value.name
      default_service = google_compute_region_backend_service.cloudrun_backends[path_matcher.value.default_service_key].id

      dynamic "path_rule" {
        for_each = path_matcher.value.path_rules
        content {
          paths   = path_rule.value.paths
          service = google_compute_region_backend_service.cloudrun_backends[path_rule.value.service_key].id

          dynamic "route_action" {
            for_each = path_rule.value.route_action != null ? [path_rule.value.route_action] : []
            content {
              dynamic "url_rewrite" {
                for_each = route_action.value.url_rewrite != null ? [route_action.value.url_rewrite] : []
                content {
                  path_prefix_rewrite = url_rewrite.value.path_prefix_rewrite
                  host_rewrite        = url_rewrite.value.host_rewrite
                }
              }
            }
          }
        }
      }
    }
  }
}
resource "google_compute_region_target_http_proxy" "http_proxy" {
  name    = "${var.internal_load_balancer_name_app}-http-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.url_map.id
}

resource "google_compute_forwarding_rule" "http_rule" {
  name                  = "${var.internal_load_balancer_name_app}-http-fw-rule"
  region                = var.region
  load_balancing_scheme = var.internal_load_balancing_scheme_app
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.http_proxy.id # Point to the regional proxy
  ip_address            = google_compute_address.internal_ip.address
  network               = var.vpc_network_self_link
  subnetwork            = var.internal_lb_subnet_self_link
}
