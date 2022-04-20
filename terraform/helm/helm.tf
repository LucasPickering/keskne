resource "helm_release" "keskne" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.18"
  namespace  = var.kube_namespace

  values = [
    file("./values.yaml")
  ]
}

resource "kubernetes_namespace" "keskne" {
  metadata {
    name = var.kube_namespace
  }
}
