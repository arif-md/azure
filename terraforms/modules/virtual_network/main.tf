resource "azurerm_virtual_network" "MOD-VNET-NETWORK" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = var.rsg.name
  #location            = azurerm_resource_group.main.location
  #resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "MOD-VNET-SNET-INTERNAL" {
  name                 = "internal"
  #resource_group_name  = "${var.rg_name}"
  resource_group_name  = var.rsg.name
  virtual_network_name = azurerm_virtual_network.MOD-VNET-NETWORK.name
  #resource_group_name  = azurerm_resource_group.main.name
  #virtual_network_name = azurerm_virtual_network.MOD-VN-NETWORK.name
  address_prefixes     = ["10.0.2.0/24"]
}
