terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.82.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
}

resource "random_pet" "name" {

}
resource "azurerm_container_registry" "default" {
  name                = "${random_pet.name.id}-acr"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  sku                 = "basic"
}

resource "azurerm_role_assignment" "default" {
  principal_id                     = azurerm_kubernetes_cluster.default.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.default.id
  skip_service_principal_aad_check = true
}

data "null_resource" "build_and_push" {
  triggers = {
    acr_id = azurerm_container_registry.default.id
  }
}

data "template_file" "helm_values" {
  template = file("${path.module}/helm/values.yaml.tpl")

  vars = {
    
    # Other variables if needed
  }
}