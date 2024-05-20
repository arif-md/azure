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
    subnet_id                     = var.subnet_internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.assign_public_ip ? azurerm_public_ip.MOD-VM[0].id : null
  }
}

resource "azurerm_network_security_group" "MOD-VM" {
  count               = length(var.nsgrules) > 0 ? 1 : 0
  name                = "${var.prefix}-nsg-${random_string.random.result}"
  location            = "${var.location}"
  resource_group_name = var.rsg.name
}

resource "azurerm_network_interface_security_group_association" "MOD-VM" {
  count               = length(var.nsgrules) > 0 ? 1 : 0
  network_interface_id      = azurerm_network_interface.MOD-VM.id
  network_security_group_id = azurerm_network_security_group.MOD-VM[0].id
}

resource "azurerm_network_security_rule" "MOD-VM" {
  /*for_each                    = {
    for ruleName, rule in var.nsgrules : ruleName => rule
      if var.assign_nsg
  }*/
  for_each                    = var.nsgrules
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.rsg.name
  network_security_group_name = azurerm_network_security_group.MOD-VM[0].name
}

resource "azurerm_linux_virtual_machine" "MOD-VM" {
  name                            = "${var.prefix}-vm-${random_string.random.result}"
  resource_group_name             = var.rsg.name
  location                        = var.location
  size                            = var.vm_size
  #delete_os_disk_on_termination   = "true"
  admin_username                  = "devops"
  admin_password                 = "P@ssw0rd1234!"
  disable_password_authentication = false
  admin_ssh_key {
    username = "devops"
    public_key = file("~/.ssh/id_rsa.pub")
  }    

  network_interface_ids           = [azurerm_network_interface.MOD-VM.id]

  os_disk {
    name                          = "${var.prefix}-osdisk-${random_string.random.result}"
    caching                       = "ReadWrite"
    storage_account_type          = "Standard_LRS"
  }

  // Check for the images here : https://learn.microsoft.com/en-us/azure/virtual-machines/linux/using-cloud-init
  // And here : https://documentation.ubuntu.com/azure/en/latest/azure-how-to/instances/find-ubuntu-images/
  // Check the logs at : /var/log/cloud-init.log
  source_image_reference {
    publisher                     = "Canonical"
    offer                         = "0001-com-ubuntu-server-focal"
    sku                           = "20_04-lts"
    version                       = "latest"
  }

  computer_name = "jenkins-server-${random_string.random.result}"
  custom_data = var.init_script != null ?  base64encode(file(var.init_script)) : null
}

