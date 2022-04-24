variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token"
}

variable "cloudflare_email" {
  type        = string
  description = "Cloudflare login email"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare DNS zone ID"
}

variable "do_region" {
  type        = string
  description = "DigitalOcean region"
  default     = "nyc1"
}

variable "do_token" {
  type        = string
  description = "DigitalOcean auth token"
}

variable "kube_config_path" {
  type        = string
  description = "Path to kubectl config file"
  default     = "~/.kube/config"
}

variable "kube_namespace" {
  type        = string
  description = "Kubernetes namespace to deploy root Keskne pods into"
  default     = "keskne"
}
