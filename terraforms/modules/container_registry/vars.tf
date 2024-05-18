variable "acr_name" {
  type        = string
  description = "ACR Name"
}

variable "rg_name" {
  type        = string
  description = "RG name in Azure"
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
}
variable "tag_billing_team" {
  type        = string
  description = "Tag to identify the billing team"
}

variable "tag_env" {
  type        = string
  description = "Tag to identify the environment"
}

variable "aks_principal_id" {
  type        = string
  description = "AKS principal id"
}
