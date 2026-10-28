variable "nom_cluster" {
  type        = string
  description = "Nom du cluster kind (contexte kubectl kind-<nom>)."
}

variable "version_argocd" {
  type        = string
  description = "Version du chart Helm argo-cd."
}
