terraform {
  required_version = ">= 1.0"
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kube_config_path)
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.kube_config_path)
}
