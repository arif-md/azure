output "rsg" {
    #value = azurerm_resource_group.rsg-project-1
    #value = azurerm_resource_group.MOD-RSG[*]
    #value = azurerm_resource_group.MOD-RSG.name
    value = azurerm_resource_group.MOD-RSG
    /*value = {
      for k, v in azurerm_resource_group.MOD-RSG : k => v.name
    } */   
    #value = {for k, v in azurerm_resource_group.MOD-RSG: k.name => v.name}
    description = "spits out new resource group"
}