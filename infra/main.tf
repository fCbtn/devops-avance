# Cluster Kubernetes local, créé dans un conteneur Docker par le provider kind.
resource "kind_cluster" "this" {
  name           = "plateforme"
  wait_for_ready = true
}

# Le provider Helm se connecte au cluster que l'on vient de déclarer.
provider "helm" {
  kubernetes = {
    host                   = kind_cluster.this.endpoint
    client_certificate     = kind_cluster.this.client_certificate
    client_key             = kind_cluster.this.client_key
    cluster_ca_certificate = kind_cluster.this.cluster_ca_certificate
  }
}

# ArgoCD, installé depuis son chart Helm officiel dans le namespace argocd.
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "10.10.3"
  namespace        = "argocd"
  create_namespace = true
  timeout          = 600
}
