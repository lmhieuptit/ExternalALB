output "dns_name_internal_alb" {
  value = google_dns_record_set.internal_alb_a_record.name
}
