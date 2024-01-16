resource "azurerm_resource_group" "MOD-RSG" {
  name     = "${var.name}-resources"
  location = "${var.location}"
}
