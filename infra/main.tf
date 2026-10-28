# Cluster Kubernetes local, créé dans un conteneur Docker par le provider kind.
resource "kind_cluster" "this" {
  name           = "plateforme"
  wait_for_ready = true
}
