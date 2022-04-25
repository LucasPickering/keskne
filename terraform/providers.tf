terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  required_version = ">= 1.0"
}

provider "cloudflare" {
  api_token            = var.cloudflare_api_token
  api_user_service_key = var.cloudflare_origin_ca_key
}

provider "digitalocean" {
  token = var.do_token
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kube_config_path)
    # This context should be created by doctl after the cluster stands up
    config_context = "do-${var.do_region}-${digitalocean_kubernetes_cluster.main.name}"
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.kube_config_path)
  # This context should be created by doctl after the cluster stands up
  config_context = "do-${var.do_region}-${digitalocean_kubernetes_cluster.main.name}"
}
