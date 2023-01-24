locals {
  # We're only ever going to have one node pool in here
  node_pool = digitalocean_kubernetes_cluster.main.node_pool[0]
}

resource "digitalocean_kubernetes_cluster" "main" {
  name    = "keskne"
  region  = "nyc1"
  version = var.kube_version
  ha      = false

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb"
    node_count = 1
  }

  # Create kubectl context for this cluster
  # TODO delete this on teardown
  provisioner "local-exec" {
    command = "doctl kubernetes cluster kubeconfig save ${self.name} --set-current-context=false"
  }
}

# Allow HTTP+HTTPS inbound on all noces (since we don't have an LB)
resource "digitalocean_firewall" "http" {
  name        = "k8s-http-inbound-${digitalocean_kubernetes_cluster.main.id}"
  droplet_ids = [for node in local.node_pool.nodes : node.droplet_id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# For now we only have one node, so grab it out of the pool so we can hit it
# directly, instead of using a load balancer
data "digitalocean_droplet" "worker_node" {
  id = local.node_pool.nodes[0].droplet_id
}
