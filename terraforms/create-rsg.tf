# Perform the following steps to execute this terraform.
# 1) update the service principal details in the power shell script "env.ps1"
# 2) execcute the power shell script in order to set the required environment variables (.\env.ps1)
# 3) terraform init/plan/apply

# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

module "resource_groups" {
  source = "./modules/resource_group"
  name     = "svc-princ-rsg"  
  location = "eastus"
}