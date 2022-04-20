variable "kube_config_path" {
  type        = string
  description = "Path to kubectl config file"
  default     = "~/.kube/config"
}

variable "kube_namespace" {
  type        = string
  description = "Kubernetes namespace to deploy root Keskne pods into"
  default     = "keskne"
}
