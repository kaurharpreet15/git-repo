terraform {
      required_version = "1.0.9"
    }


provider "azurerm" {
features {}
subscription_id = "a86fac47-6d7e-4b86-aab1-5a6ec1e76f15"
tenant_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"
client_id = "eaa3456f-aa49-4f04-988f-126dbc45f882"
client_secret = "8hlNrRN5tSt~8e6i-mH8cAIP.3G-29WTDI"
}

data "azurerm_virtual_network" "virtualnetwork" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg_name
}

data "azurerm_resource_group" "resourcegroup" {
    name = var.rg_name
    //location = var.location
}

module "subnet1" {
  source = "./subnet"
  subnet_name = "app_subnet"
  address_prefix = "10.1.2.0/27"
}

module "mysqldb"{
  source = "./AzureDB for MySQL"
  mysqlserver_name = "hakmysqlserver"
  adminaccount = "hakadmin"
  adminpassword = "W@heguru1"
  sku = "B_Gen5_2"
  storage_size = "5120"
  mysqlversion = "5.7"
  mysqldbname = "hakmysqldb"
}


