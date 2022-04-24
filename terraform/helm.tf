# Deploy the nginx ingress chart, so that individual webapps can define ingress
# rules for their own routing
resource "helm_release" "keskne" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.0.18"
  namespace        = var.kube_namespace
  create_namespace = true

  values = [
    file("./values.yaml")
  ]
}
