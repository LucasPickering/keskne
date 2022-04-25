resource "digitalocean_project" "keskne" {
  name        = "keskne"
  description = "Central hosting for a bunch of web apps"
  purpose     = "Web Application"
  environment = "Production"
}

# Resources need to be listed separately so that the list isn't authoritative.
# Otherwise, resources added to the project outside terraform (e.g. volumes
# allocated by kubernetes) will be ejected from the project
resource "digitalocean_project_resources" "keskne" {
  project   = digitalocean_project.keskne.id
  resources = [digitalocean_kubernetes_cluster.main.urn]
}
