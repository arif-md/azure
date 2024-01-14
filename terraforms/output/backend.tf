terraform {
    backend "azurerm" {
        storage_account_name = "cs7100320033417bc0b"
        container_name = "myfirstcontainer"
        key = "vars.terraform.tfstate"
        sas_token = "sp=racwdli&st=2024-01-14T19:51:42Z&se=2025-01-15T03:51:42Z&sv=2022-11-02&sr=c&sig=PkoHKSUsTYRnXO9Zcmg1r5u0RaqCmTeIvRURpw%2FmbIo%3D"
    }
}