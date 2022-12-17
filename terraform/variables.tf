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

variable "kube_version" {
  type        = string
  description = "Kubernetes cluster version in DigitalOcean. Grab the latest from `doctl kubernetes options versions`"
  default     = "1.25.4-do.0"
}
