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