terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.3"
    }
  }
}

variable "version_chart" {
  type        = string
  description = "Version du chart argo-cd."
}

# ArgoCD, installé depuis son chart Helm officiel dans le namespace argocd.
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.version_chart
  namespace        = "argocd"
  create_namespace = true
  timeout          = 600
}
