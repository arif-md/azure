variable "random_string" {
    type = string
    description = "random string that gets prepended to the name of the resources"
    default = ""
}
variable "location" {
    type = string
}
variable "rsg" {
    description = "required resource group definition"
}
variable "subnet_internal" {
    description = "required subnet internal definition"
}
variable "vm_size" {
    type = string
}
variable "prefix" {
    type = string
}
variable "init_script" {
    type = string
    nullable = true
    default = null
}
variable "disable_password_authentication" {
  type    = bool  
}
variable "admin_username" {
    type = string
    description = "admin user name of the VM"
}
variable "admin_password" {
    type = string
    //default = "Admin@1234567890"
    description = "password for the admin user"
}

variable "assign_public_ip" {
    type = bool
    nullable = true
    default = false
    description = "Should a public IP address assigned to VM?"
}
variable "nsgrules" {
    default = {}
    description = "NSG rules in map"
}
variable "image_publisher" {
  type        = string
}
variable "image_offer" {
  type        = string
}
variable "image_ver" {
  type        = string
}
variable "image_sku" {
  type        = string
}
