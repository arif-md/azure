output "public_ip" {
  value = var.assign_public_ip ? azurerm_public_ip.MOD-VM[0].ip_address : null
}