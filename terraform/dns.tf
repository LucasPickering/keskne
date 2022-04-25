locals {
  kube_ip = data.digitalocean_droplet.worker_node.ipv4_address
}

data "cloudflare_zone" "root" {
  name = var.cloudflare_zone
}

resource "cloudflare_record" "beta_spray" {
  zone_id = data.cloudflare_zone.root.id
  name    = "betaspray"
  value   = local.kube_ip
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "laulud" {
  zone_id = data.cloudflare_zone.root.id
  name    = "laulud"
  value   = local.kube_ip
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "osrs_hiscore" {
  zone_id = data.cloudflare_zone.root.id
  name    = "osrs-hiscore"
  value   = local.kube_ip
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "rps" {
  zone_id = data.cloudflare_zone.root.id
  name    = "rps"
  value   = local.kube_ip
  type    = "A"
  ttl     = 1
  proxied = true
}
