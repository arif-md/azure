provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

locals {
    prefix     = "terraform"
    location1  = "eastus"
    location2  = "eastus2"
    resource_groups = {
      "rsg1" = { name = "${local.prefix}-${local.location1}-resources", location = local.location1 },
      "rsg2" = { name = "${local.prefix}-${local.location2}-resources", location = local.location2 }
    }    
    vm_size    = "Standard_DS1_v2"
}

module "resource_groups" {
  source = "../modules/resource_group"
  for_each = local.resource_groups

  name  = each.value.name  
  location  = each.value.location
}

/*output "all_outputs" {
  value = module.resource_groups.*
}*/

/*output "rsg_map" {
  #value = module.resource_groups["rsg1"].rsg
  value = { for k in keys(local.resource_groups) : k => module.resource_groups[k].rsg   }
}*/
locals {
  #value = module.resource_groups["rsg1"].rsg
  rsg_map = { for k in keys(local.resource_groups) : k => module.resource_groups[k].rsg   }
}



module "virtual_network" {
  source = "../modules/virtual_network"

  for_each = local.resource_groups  
  prefix = local.prefix  
  location = local.location2
  rsg = local.rsg_map[each.key]
}

/*module "virtual_machine1" {
  source = "../modules/virtual_machine"
  location            = module.resource_group.rsg.location
  rsg = module.resource_group.rsg
  subnet_internal=module.virtual_network.subnet_internal
  vm_size = local.vm_size
  prefix = local.prefix  
}*/