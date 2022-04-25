# Deploy the nginx ingress chart, so that individual webapps can define ingress
# rules for their own routing
resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.0.18"
  namespace        = var.kube_namespace
  create_namespace = true

  values = [
    file("./values-ingress.yaml")
  ]
}

resource "helm_release" "metrics_server" {
  name             = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server"
  chart            = "metrics-server"
  version          = "3.8.2"
  namespace        = var.kube_namespace
  create_namespace = true
}
