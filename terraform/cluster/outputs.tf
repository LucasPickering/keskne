output "beta_spray_hostname" {
  description = "Beta Spray FQDN"
  value       = cloudflare_record.beta_spray.hostname
}

output "cluster_name" {
  description = "Kubernetes cluster name"
  value       = digitalocean_kubernetes_cluster.main.name
}

output "cluster_ip" {
  description = "Kubernetes cluster management IP"
  value       = digitalocean_kubernetes_cluster.main.ipv4_address
}

output "laulud_hostname" {
  description = "Laulud FQDN"
  value       = cloudflare_record.laulud.hostname
}

output "osrs_hiscore_hostname" {
  description = "OSRS Hiscore Proxy FQDN"
  value       = cloudflare_record.osrs_hiscore.hostname
}

output "project_name" {
  description = "Digitalocean project name"
  value       = digitalocean_project.keskne.name
}

output "public_ip" {
  description = "Kubernetes cluster public application IP"
  value       = data.digitalocean_droplet.worker_node.ipv4_address
}

output "rps_hostname" {
  description = "RPS FQDN"
  value       = cloudflare_record.rps.hostname
}
