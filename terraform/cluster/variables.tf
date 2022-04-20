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
