variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token"
}

variable "cloudflare_origin_ca_key" {
  type        = string
  description = "Cloudflare Origin CA key (different from API token)"
}

variable "cloudflare_zone" {
  type        = string
  description = "Cloudflare DNS zone name"
  default     = "lucaspickering.me"
}

variable "gcp_project_id" {
  description = "GCP project id"
  default     = "keskne-347510"
  type        = string
}

variable "gcp_region" {
  # Always Free for storage isn't available in east4
  # https://cloud.google.com/storage/pricing#cloud-storage-always-free
  description = "GCP region"
  default     = "us-east1"
  type        = string
}

variable "gcp_zone" {
  # GKE control plane is only free for Zonal Clusters
  # https://cloud.google.com/kubernetes-engine/pricing#standard_mode
  description = "GCP zone"
  default     = "us-east1-c"
  type        = string
}

variable "kube_namespace" {
  type        = string
  description = "Kubernetes namespace to deploy root Keskne pods into"
  default     = "keskne"
}
