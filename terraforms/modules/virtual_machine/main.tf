#Public IP definition
resource "azurerm_public_ip" "MOD-VM" {
  count               = var.assign_public_ip ? 1 : 0
  name                = "${var.prefix}-public-ip-${var.random_string}"
  location            = var.location
  resource_group_name = var.rsg.name
  allocation_method   = "Static"  # Choose "Dynamic" if you want a dynamic IP
  sku                 = "Standard"  # Choose "Basic" or "Standard" SKU
}

# Network interface card definition.
resource "azurerm_network_interface" "MOD-VM" {
  name                = "${var.prefix}-nic-${var.random_string}"
  location            = var.location
  resource_group_name = var.rsg.name

  ip_configuration {
    name                          = "${var.prefix}-ipconfig-${var.random_string}"
    subnet_id                     = var.subnet_internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.assign_public_ip ? azurerm_public_ip.MOD-VM[0].id : null
  }
}

resource "azurerm_network_security_group" "MOD-VM" {
  count               = length(var.nsgrules) > 0 ? 1 : 0
  name                = "${var.prefix}-nsg-${var.random_string}"
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
  resource_group_name         = var.rsg.name
  network_security_group_name = azurerm_network_security_group.MOD-VM[0].name
  destination_address_prefix  = each.value.destination_address_prefix == "MAP_TO_VM_PVT_IP" ? azurerm_network_interface.MOD-VM.private_ip_address : "*"
}

resource "azurerm_linux_virtual_machine" "MOD-VM" {
  name                            = "${var.prefix}-vm-${var.random_string}"
  resource_group_name             = var.rsg.name
  location                        = var.location
  size                            = var.vm_size
  #delete_os_disk_on_termination  = "true"
  admin_username                  = "${var.admin_username}"
  admin_password                  = "${var.admin_password}"
  disable_password_authentication = "${var.disable_password_authentication}"
  admin_ssh_key {
    username = "${var.admin_username}"
    public_key = file("~/.ssh/id_rsa.pub")
  }    

  network_interface_ids           = [azurerm_network_interface.MOD-VM.id]

  os_disk {
    name                          = "${var.prefix}-osdisk-${var.random_string}"
    caching                       = "ReadWrite"
    storage_account_type          = "Standard_LRS"
  }

  // Check for the images here : https://learn.microsoft.com/en-us/azure/virtual-machines/linux/using-cloud-init
  // And here : https://documentation.ubuntu.com/azure/en/latest/azure-how-to/instances/find-ubuntu-images/
  source_image_reference {
    publisher                     = "${var.image_publisher}"
    offer                         = "${var.image_offer}"
    sku                           = "${var.image_sku}"
    version                       = "${var.image_ver}"
  }

  computer_name = "${var.prefix}-host-${var.random_string}"
  custom_data = var.init_script != null ?  base64encode(file(var.init_script)) : null
}

