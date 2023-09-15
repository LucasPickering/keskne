locals {
  full_repo = "${var.github_repository_owner}/${var.github_repository}"
}

# Create a new service account to access GKE creds
resource "google_service_account" "service_account" {
  # Make sure to override project from the parent provider
  project      = var.gcp_project_id
  account_id   = var.service_account_id
  display_name = "${local.full_repo} GitHub CI Service Account"
  description  = "Service account for ${local.full_repo} to access GKE creds from GitHub CI"
}

module "oidc" {
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  project_id  = var.gcp_project_id
  pool_id     = "github-pool"
  provider_id = "github-provider"
  sa_mapping = {
    (google_service_account.service_account.account_id) = {
      sa_name   = google_service_account.service_account.name
      attribute = "attribute.repository/${local.full_repo}"
    }
  }
}

# Use the `member` resource so we don't wipe out role assignments for other projects
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "gke_cluster_viewer" {
  project = var.gcp_project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

# Create variables/secrets in Github to access the SA and cluster

locals {
  variables = {
    (var.github_cluster_name_variable)     = var.kubernetes_cluster_name
    (var.github_cluster_location_variable) = var.kubernetes_cluster_location
  }
  secrets = {
    (var.github_service_account_secret)      = google_service_account.service_account.email
    (var.github_workload_id_provider_secret) = module.oidc.provider_name
  }
}

resource "github_actions_variable" "variables" {
  for_each = local.variables
  # Github only wants the repo name, not the user
  repository    = var.github_repository
  variable_name = each.key
  value         = each.value
}

resource "github_actions_secret" "secrets" {
  for_each        = local.secrets
  repository      = var.github_repository
  secret_name     = each.key
  plaintext_value = each.value
}
