resource "digitalocean_project" "keskne" {
  name        = "keskne"
  description = "Central hosting for a bunch of web apps"
  purpose     = "Web Application"
  environment = "Production"
  resources   = [digitalocean_kubernetes_cluster.main.urn]
}
