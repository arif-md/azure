provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

locals {
    prefix = "terraform"
    location = "eastus2"
    vm_size = "Standard_DS1_v2"
}

module "resource_group" {
  source = "../modules/resource_group"
  prefix = local.prefix  
  location = local.location
}

module "virtual_network" {
  source = "../modules/virtual_network"
  prefix = local.prefix  
  location = local.location
  rsg = module.resource_group.rsg
  #rg_name = azurerm_resource_group.main.name
  #depends_on = [azurerm_resource_group.main]
}

module "virtual_machine1" {
  source = "../modules/virtual_machine"
  location            = module.resource_group.rsg.location
  rsg = module.resource_group.rsg
  #rg_name = azurerm_resource_group.main.name
  subnet_internal=module.virtual_network.subnet_internal
  #subnet_id = azurerm_subnet.internal.id
  vm_size = local.vm_size
  prefix = local.prefix  
}

/*module "virtual_machine2" {
  source = "./modules/virtual_machine"
  location            = azurerm_resource_group.main.location
  rg_name = azurerm_resource_group.main.name
  subnet_id = azurerm_subnet.internal.id
  vm_size = local.vm_size
  prefix = local.prefix
}*/