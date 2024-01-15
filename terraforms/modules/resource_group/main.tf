resource "azurerm_resource_group" "rsg-project-1" {
  name     = "${var.prefix}-resources"
  location = "${var.location}"
}
