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
variable "assign_public_ip" {
    type = bool
    nullable = true
    default = false
    description = "Should a public IP address assigned to VM?"
}