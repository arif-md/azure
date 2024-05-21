variable "random_string" {
    type = string
    description = "random string that gets prepended to the name of the resources"
    default = ""
}
variable "prefix" {
    type = string
}
variable "location" {
    type = string
}
variable "rsg" {
    description = "required resource group definition"
}
