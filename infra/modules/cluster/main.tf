terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.11"
    }
  }
}

variable "nom" {
  type        = string
  description = "Nom du cluster kind (et du contexte kubectl kind-<nom>)."
}

resource "kind_cluster" "this" {
  name           = var.nom
  wait_for_ready = true
}

# Les quatre sorties dont le provider Helm a besoin pour joindre le cluster.
output "endpoint" {
  value = kind_cluster.this.endpoint
}

output "client_certificate" {
  value = kind_cluster.this.client_certificate
}

output "client_key" {
  value     = kind_cluster.this.client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value = kind_cluster.this.cluster_ca_certificate
}
