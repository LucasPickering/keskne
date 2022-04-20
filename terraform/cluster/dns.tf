locals {
  kube_ip = data.digitalocean_droplet.worker_node.ipv4_address
}

resource "cloudflare_record" "beta_spray" {
  zone_id = var.cloudflare_zone_id
  name    = "betaspray"
  value   = local.kube_ip
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "laulud" {
  zone_id = var.cloudflare_zone_id
  name    = "laulud"
  value   = local.kube_ip
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "osrs_hiscore" {
  zone_id = var.cloudflare_zone_id
  name    = "osrs-hiscore"
  value   = local.kube_ip
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "rps" {
  zone_id = var.cloudflare_zone_id
  name    = "rps"
  value   = local.kube_ip
  type    = "A"
  ttl     = 1
  proxied = true
}
