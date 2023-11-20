# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "3.0.2"
#     }
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = ">= 2.0.1"
#     }

#     helm = {
#       source  = "hashicorp/helm"
#       version = ">= 2.0.0"
#     }
#   }
# }

data "terraform_remote_state" "aks" {
  backend = "local"
  config = {
    path = "../learn-terraform-provision-aks-cluster/terraform.tfstate"
  }
}

# # Retrieve AKS cluster information
# provider "azurerm" {
#   features {}
# }

# provider "helm" {
#   # Configuration options
#   kubernetes {
#     config_path = "~/.kube/config"
#     config_context = "smooth-reindeer-aks"
#     # config_context = data.terraform_remote_state.aks.outputs.kubernetes_cluster_name
#   }
# }

data "azurerm_kubernetes_cluster" "cluster" {
  name                = data.terraform_remote_state.aks.outputs.kubernetes_cluster_name
  resource_group_name = data.terraform_remote_state.aks.outputs.resource_group_name
}


# provider "kubernetes" {
#   host = data.azurerm_kubernetes_cluster.cluster.kube_config.0.host

#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
# }

# resource "kubernetes_namespace" "fitnessappnamespace" {
#   metadata {
#     annotations = {
#       name = "fitnessappnamespace"
#     }

#     labels = {
#       mylabel = "namespace"
#     }

#     name = "fitnessappnamespace"
#   }
# }

# resource "helm_release" "fitnessapp" {
#   name = "fitnessapp-release"
#   # repository = "../../K8S-helm/fitnessapp"
#   chart = "./fitnessapp-0.1.0.tgz"
#   values = [
#     "${file("../../K8S-helm/fitnessapp/values.yaml")}"
#   ]
# }

# resource "helm_release" "ingress" {
#   name = "ingress-release"
#   #repository = "../../K8S-helm/ingress"
#   chart = "./ingress-0.1.0.tgz"
#   values = [
#     "${file("../../K8S-helm/ingress/values.yaml")}"
#   ]
# }

# resource "helm_release" "api" {
#   name = "api-release"
#   #repository = "../../K8S-helm/api"
#   chart = "C:/Users/robin/Desktop/Projects/Examensarbete/Infrastructure/Terraform/learn-terraform-deploy-nginx-kubernetes/ingress-0.1.0.tgz"
#   values = [
#     "${file("../../K8S-helm/api/values.yaml")}"
#   ]
# }