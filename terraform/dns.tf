locals {
  kube_ip = data.google_compute_instance.worker_node.network_interface[0].access_config[0].nat_ip
}

data "cloudflare_zone" "main" {
  name = var.cloudflare_zone
}

resource "cloudflare_record" "laulud" {
  zone_id = data.cloudflare_zone.main.id
  name    = "laulud"
  value   = local.kube_ip
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "osrs_hiscore" {
  zone_id = data.cloudflare_zone.main.id
  name    = "osrs-hiscore"
  value   = local.kube_ip
  type    = "A"
  ttl     = 1
  proxied = true
}
