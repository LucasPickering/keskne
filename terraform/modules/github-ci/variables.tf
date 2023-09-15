variable "gcp_project_id" {
  description = "ID of the Keskne GCP project"
  type        = string
  default     = "keskne-347510"
}

variable "kubernetes_cluster_name" {
  description = "Name of the Kubernetes cluster (within GCP) that we'll deploy to"
  type        = string
  default     = "keskne-gke"
}

variable "kubernetes_cluster_location" {
  description = "Location (region or zone ) of the Kubernetes cluster (within GCP) that we'll deploy to"
  type        = string
  default     = "us-east1-c"
}

variable "github_cluster_name_variable" {
  description = "Name of the variable to create in GitHub that will hold the Keskne cluster name"
  type        = string
  default     = "KESKNE_CLUSTER_NAME"
}

variable "github_cluster_location_variable" {
  description = "Name of the variable to create in GitHub that will hold the Keskne cluster location"
  type        = string
  default     = "KESKNE_CLUSTER_LOCATION"
}

variable "github_service_account_secret" {
  description = "Name of the secret to create in GitHub that will hold the service account email"
  type        = string
  default     = "KESKNE_GOOGLE_SERVICE_ACCOUNT"
}

variable "github_workload_id_provider_secret" {
  description = "Name of the secret to create in GitHub that will hold the workload ID provider"
  type        = string
  default     = "KESKNE_GOOGLE_WORKLOAD_ID_PROVIDER"
}

variable "github_repository_owner" {
  description = "Owner of the *consuming* GitHub repository, e.g. `LucasPickering`"
  type        = string
}

variable "github_repository" {
  description = "ID of the *consuming* GitHub repository, e.g. `keskne`"
  type        = string
}

variable "service_account_id" {
  description = "ID of the service account to create in the Keskne project"
  type        = string
}
