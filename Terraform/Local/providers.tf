terraform {
  required_version = ">=1.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
     helm = {
      source = "hashicorp/helm"
      version = "2.11.0"
    }
  }
}

provider "helm" {
  # Configuration options
   kubernetes {
    config_path = "~/.kube/config"
   }
    # localhost registry with password protection
  registry {
    url = "oci://localhost:8080"
    username = "username"
    password = "password"
  }

  # private registry
  registry {
    url = "oci://private.registry"
    username = "username"
    password = "password"
  }
}
