# La plateforme : le cluster kind et ArgoCD, chacun isolé dans son module.

module "cluster" {
  source = "./modules/cluster"
  nom    = var.nom_cluster
}

# Le provider Helm se connecte au cluster déclaré par le module cluster,
# en lisant ses sorties (pas des valeurs copiées en dur).
provider "helm" {
  kubernetes = {
    host                   = module.cluster.endpoint
    client_certificate     = module.cluster.client_certificate
    client_key             = module.cluster.client_key
    cluster_ca_certificate = module.cluster.cluster_ca_certificate
  }
}

module "argocd" {
  source        = "./modules/argocd"
  version_chart = var.version_argocd
  depot         = var.depot
}

# Les ressources ont changé d'adresse en passant dans des modules. Les blocs
# moved disent à OpenTofu que ce sont les mêmes ressources, ce qui évite de
# détruire puis recréer le cluster et ArgoCD.
moved {
  from = kind_cluster.this
  to   = module.cluster.kind_cluster.this
}

moved {
  from = helm_release.argocd
  to   = module.argocd.helm_release.argocd
}
