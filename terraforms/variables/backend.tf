terraform {
    backend "azurerm" {
        storage_account_name = "cs7100320033417bc0b"
        container_name = "myfirstcontainer"
        key = "vars.terraform.tfstate"
        sas_token = "sp=racwdli&st=2024-01-13T20:07:11Z&se=2024-01-14T04:07:11Z&spr=https&sv=2022-11-02&sr=c&sig=SRwjIgy394Dsloqe57qzE42VgOmSB4DXX9hJpOEYaW0%3D"
    }
}