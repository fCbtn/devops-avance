variable "nom_cluster" {
  type        = string
  description = "Nom du cluster kind (contexte kubectl kind-<nom>)."
}

variable "version_argocd" {
  type        = string
  description = "Version du chart Helm argo-cd."
}

variable "depot" {
  type        = string
  description = "URL HTTPS du dépôt git surveillé par ArgoCD."
}
