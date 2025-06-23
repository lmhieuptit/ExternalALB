output "internal_lb_ip_address" {
  value = google_compute_address.internal_ip.address
}