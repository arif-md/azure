# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_version = ">=1.3.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "RSG-ref" {
  name     =  var.rg-name
  location = "${lookup(var.locations, "e-usa")}"
}

# Create another resource group
resource "azurerm_resource_group" "RSG-ref2" {
  name     =  var.rg-name2
  location = "${lookup(var.locations, "w-eur")}"
}

# Create a virtual network within the resource group
#resource "azurerm_virtual_network" "example" {
#  name                = "example-network"
#  resource_group_name = azurerm_resource_group.example.name
#  location            = azurerm_resource_group.example.location
#  address_space       = ["10.0.0.0/16"]
#}
