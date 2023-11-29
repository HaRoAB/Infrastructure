# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "prefix" {
  length    = 2
  separator = ""
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "${random_pet.prefix.id}-rg"
  location = var.location

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${random_pet.prefix.id}-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"
  kubernetes_version  = "1.28.3"

  default_node_pool {
    name            = "default"
    node_count      = var.node_count
    vm_size         = var.node_size
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control_enabled = true

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_container_registry" "default" {
  depends_on = [ azurerm_resource_group.default ]
  name                = "${random_pet.prefix.id}acr"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  sku                 = "Basic"
}

resource "azurerm_role_assignment" "default" {
  depends_on = [ azurerm_kubernetes_cluster.default, azurerm_container_registry.default ]
  principal_id                     = azurerm_kubernetes_cluster.default.service_principal.0.client_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.default.id
  skip_service_principal_aad_check = true
}

resource "kubernetes_namespace" "fitnessappnamespace" {
  depends_on = [azurerm_kubernetes_cluster.default]
  metadata {
    name = "fitnessappnamespace"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config" # Set the path to your kubeconfig file

  host                   = azurerm_kubernetes_cluster.default.kube_config.0.host
  # username               = azurerm_kubernetes_cluster.default.kube_config.0.username
  # password               = azurerm_kubernetes_cluster.default.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.default.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.default.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.default.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  # Configuration options
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "null_resource" "get_credentials" {
  depends_on = [azurerm_kubernetes_cluster.default]
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${azurerm_resource_group.default.name} --name ${azurerm_kubernetes_cluster.default.name} --overwrite-existing"
  }
}

resource "null_resource" "config_kubectl" {
  depends_on = [null_resource.get_credentials]
  provisioner "local-exec" {
    command = "kubectl config use-context ${azurerm_kubernetes_cluster.default.name}"
  }
}
// Install Nginx Ingress Controller ---------------------------------------------
resource "null_resource" "apply_deploy_yaml" {
  depends_on = [null_resource.config_kubectl]
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/cloud/deploy.yaml -n ingress-nginx"
  }
}

// Kubernetes Helm Charts ------------------------------------------------------
resource "helm_release" "fitnessapp" {
  depends_on = [null_resource.config_kubectl, kubernetes_namespace.fitnessappnamespace]
  name       = "fitnessapp-release"
  chart = "./fitnessapp-0.1.0.tgz"
  values = [
      <<-EOF
      image:
        repository: ${azurerm_container_registry.default.login_server}/fitnessapp
        tag: latest
      EOF
  ]
}

resource "helm_release" "ingress" {
  depends_on = [null_resource.config_kubectl, kubernetes_namespace.fitnessappnamespace]
  name       = "ingress-release"
  chart = "./ingress-0.1.0.tgz"
  values = [
      <<-EOF
      image:
        repository: ${azurerm_container_registry.default.login_server}/ingress
        tag: latest
      EOF
  ]
}

resource "helm_release" "api" {
  depends_on = [null_resource.config_kubectl, kubernetes_namespace.fitnessappnamespace]
  name       = "api-release"
  chart = "./api-0.1.0.tgz"
  values = [
      <<-EOF
      image:
        repository: ${azurerm_container_registry.default.login_server}/api
        tag: latest
      EOF
  ]
}

resource "helm_release" "mongodb" {
  depends_on = [null_resource.config_kubectl, kubernetes_namespace.fitnessappnamespace]
  name       = "mongodb-release"
  chart = "./mongodb-0.1.0.tgz"
  values = [
      <<-EOF
      image:
        repository: ${azurerm_container_registry.default.login_server}/mongodb
        tag: latest
      EOF
  ]
}


