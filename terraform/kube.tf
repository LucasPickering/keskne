# Based on https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/main/gke.tf

data "google_container_engine_versions" "gke_version" {
  location       = var.gcp_zone
  version_prefix = "1.27."
}

resource "google_container_cluster" "main" {
  name     = "keskne-gke"
  location = var.gcp_zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# We only allocate a single node, and we'll expose it directly so we don't need
# a load balancer
resource "google_container_node_pool" "main" {
  name     = google_container_cluster.main.name
  cluster  = google_container_cluster.main.name
  location = var.gcp_zone

  version    = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.gcp_project_id
    }

    preemptible  = true
    machine_type = "n1-standard-1" # TODO adjust this?
    tags         = ["gke-node", "${var.gcp_project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# Find the single worker node we created. We're using a hacky setup with only
# one node that's accessed directly, so we don't need a load balancer
data "google_compute_instance_group" "worker_pool" {
  self_link = google_container_node_pool.main.managed_instance_group_urls[0]
}

data "google_compute_instance" "worker_node" {
  self_link = tolist(data.google_compute_instance_group.worker_pool.instances)[0]
}
