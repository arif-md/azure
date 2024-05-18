module "resource_groups_acr" {
  source = "../resource_group"
  name     = var.rg_name 
  location = var.location
}

resource "azurerm_container_registry" "MOD-ACR" {
  name                = var.acr_name
  resource_group_name = module.resource_groups_acr.rsg.name
  location            = var.location
  sku                 = "Standard" # use Premium for geo replication
  admin_enabled       = false
  /*georeplications {
    location                = var.acr_geo_replicaton_location_1 # cannot be same location as ACR location
    zone_redundancy_enabled = true
    tags                    = {
      Billing = var.tag_billing_team
      Environment = var.tag_env
    }
  }*/
  /*georeplications {
      location                = "North Europe"
      zone_redundancy_enabled = true
      tags                    = {}
  }*/
}
// Note: Assigning roles in this way need a special previlege of "Owner" for the principal on behalf of which
// this role assignment is being peformed, i.e, 
resource "azurerm_role_assignment" "MOD-ACR" {
  principal_id                     = var.aks_principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.MOD-ACR.id
  skip_service_principal_aad_check = true
}

