# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# variable "appId" {
#   description = "Azure Kubernetes Service Cluster service principal"
# }

# variable "password" {
#   description = "Azure Kubernetes Service Cluster password"
# }

variable "location" {
  description = "Azure Kubernetes Service Cluster location"
  default     = "swedencentral"
}

variable "node_count" {
  description = "Azure Kubernetes Service Cluster node count"
  default     = 2
}

variable "node_size" {
  description = "Azure Kubernetes Service Cluster node size"
  default     = "Standard_D2_v2"
}
