output "cluster_name" {
  description = "Kubernetes cluster name"
  value       = google_container_cluster.main.name
}

output "cluster_ip" {
  description = "Kubernetes cluster management IP"
  value       = google_container_cluster.main.endpoint
}

output "gcp_region" {
  description = "GCP region name"
  value       = var.gcp_region
}

output "gcp_zone" {
  description = "GCP zone name"
  value       = var.gcp_zone
}

output "laulud_hostname" {
  description = "Laulud FQDN"
  value       = cloudflare_record.laulud.hostname
}

output "osrs_hiscore_hostname" {
  description = "OSRS Hiscore Proxy FQDN"
  value       = cloudflare_record.osrs_hiscore.hostname
}

output "public_ip" {
  # The expression to grab the IP is long so re-use from DNS
  description = "Kubernetes cluster public application IP"
  value       = cloudflare_record.laulud.value
}
