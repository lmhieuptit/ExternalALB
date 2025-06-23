resource "google_dns_managed_zone" "alb_internal_private_zone" {
  name        = var.cloud_dns_name
  dns_name    = var.cloud_dns_dns_name
  description = "Private DNS zone for internal ALB"
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = var.vpc_network_self_link
    }
  }
}

resource "google_dns_record_set" "internal_alb_a_record" {
  name         = "${var.google_dns_record_set_name}.${google_dns_managed_zone.alb_internal_private_zone.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.alb_internal_private_zone.name
  rrdatas      = [var.google_dns_record_set_rrdatas]
}
