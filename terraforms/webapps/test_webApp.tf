# Perform the following steps to execute this terraform.
#  1) update the service principal details in the power shell script "env.ps1"
#  2) execute the power shell script in order to set the required environment variables (.\env.ps1)
#  3) terraform init/plan/apply

# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.74.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
module "resource_groups" {
  source = "../modules/resource_group"
  name = "rsg-webapps"
  location = "eastus" 
}

# get the resource group details from above module execution.
locals {
  rsg = module.resource_groups.rsg
}

# Create a service plan. 
resource "azurerm_service_plan" "svc-plan" {
  name                = "svc-plan-spring-boot-demo-1"
  location            = local.rsg.location
  resource_group_name = local.rsg.name
  os_type             = "Linux"
  sku_name = "F1"
}

# Create a web app
resource "azurerm_linux_web_app" "linux_webapp" {
  name                = "spring-boot-demo-1"
  location            = local.rsg.location
  resource_group_name = local.rsg.name
  service_plan_id = azurerm_service_plan.svc-plan.id
  public_network_access_enabled = true
  #tags = var.custom_tags

  site_config {
    always_on = false
    application_stack {
      java_version = 17
      java_server = "TOMCAT"
      java_server_version = "10.0"
      #To list all the available stacks, run az webapp list-runtimes --linux
    }
  }
}

output "resource_group_name" {
  value = local.rsg.name
}

output "service_plan_name" {
  value = azurerm_service_plan.svc-plan.name
}

output "web_app_name" {
  value = azurerm_linux_web_app.linux_webapp.name
}

