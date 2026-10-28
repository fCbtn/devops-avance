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

variable "depot" {
  type        = string
  description = "URL HTTPS du dépôt git qu'ArgoCD surveille."
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

# L'application racine (app-of-apps) : elle surveille le dossier deploy/argocd du
# dépôt et y crée les Applications qui s'y trouvent (api-dev, api-prod).
resource "helm_release" "apps" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "2.0.6"
  namespace  = "argocd"
  timeout    = 600

  values = [yamlencode({
    applications = {
      racine = {
        namespace = "argocd"
        project   = "default"
        source = {
          repoURL        = var.depot
          targetRevision = "main"
          path           = "deploy/argocd"
        }
        destination = {
          server    = "https://kubernetes.default.svc"
          namespace = "argocd"
        }
        syncPolicy = {
          automated = {
            prune    = true
            selfHeal = true
          }
        }
      }
    }
  })]

  depends_on = [helm_release.argocd]
}
