resource "random_string" "random" {
  length           = 5
  numeric = true
  special          = false
  override_special = "/@£$"
}
#Public IP definition
resource "azurerm_public_ip" "MOD-VM" {
  count               = var.assign_public_ip ? 1 : 0
  name                = "${var.prefix}-public-ip-${random_string.random.result}"
  location            = var.location
  resource_group_name = var.rsg.name
  allocation_method   = "Static"  # Choose "Dynamic" if you want a dynamic IP
  sku                 = "Standard"  # Choose "Basic" or "Standard" SKU
}

# Network interface card definition.
resource "azurerm_network_interface" "MOD-VM" {
  name                = "${var.prefix}-nic-${random_string.random.result}"
  location            = var.location
  resource_group_name = var.rsg.name

  ip_configuration {
    name                          = "${var.prefix}-ipconfig-${random_string.random.result}"
    subnet_id = var.subnet_internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.assign_public_ip ? azurerm_public_ip.MOD-VM[0].id : null
  }
}
resource "azurerm_virtual_machine" "MOD-VM" {
  name                  = "${var.prefix}-vm-${random_string.random.result}"
  location            = var.location
  resource_group_name = var.rsg.name
  network_interface_ids = [azurerm_network_interface.MOD-VM.id]
  vm_size               = var.vm_size
  delete_os_disk_on_termination = "true"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-osdisk-${random_string.random.result}"
    create_option     = "FromImage"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "devops"
    admin_password = "Password1234!"
    custom_data = var.init_script != null ? file(var.init_script) : null
  }
  
  os_profile_linux_config {
    disable_password_authentication = false
  }
}
