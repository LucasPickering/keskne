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
  set {
    name  = "controller.extraArgs.default-ssl-certificate"
    value = "${var.kube_namespace}/${kubernetes_secret.ssl_certificate.metadata[0].name}"
  }
}

resource "kubernetes_namespace" "main" {
  metadata {
    name = var.kube_namespace
  }
}

resource "kubernetes_secret" "ssl_certificate" {
  depends_on = [kubernetes_namespace.main]

  metadata {
    name      = "ssl-certificate"
    namespace = var.kube_namespace
  }

  data = {
    "tls.crt" = cloudflare_origin_ca_certificate.main.certificate
    "tls.key" = tls_private_key.main.private_key_pem
  }

  type = "kubernetes.io/tls"
}
