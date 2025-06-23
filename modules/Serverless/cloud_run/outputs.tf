output "cloud_run_service_urls" {
  value       = { for key, service in google_cloud_run_service.cloud_run_service : key => service.status[0].url }
  description = "A map of Cloud Run service names to their endpoint URLs"
}