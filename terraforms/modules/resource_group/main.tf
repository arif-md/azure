resource "azurerm_resource_group" "MOD-RSG" {
  name     = "${var.name}"
  location = "${var.location}"
}
