variable "rg_name" {
  type        = string
  description = "RG name in Azure"
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
}

variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
  validation {
    condition     = var.system_node_count > 0
    error_message = "system node count must be greater than 0."
  }  
}

variable "system_node_size" {
  type        = string
  description = "Size of each AKS worker node"
}

variable "node_resource_group" {
  type        = string
  description = "RG name for cluster resources in Azure"
}

variable "tag_billing_team" {
  type        = string
  description = "Tag to identify the billing team"
}

variable "tag_env" {
  type        = string
  description = "Tag to identify the environment"
}
