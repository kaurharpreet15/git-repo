terraform {
      required_version = "1.0.9"
    }


provider "azurerm" {
features {}

}

data "azurerm_virtual_network" "virtualnetwork" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg_name
}

data "azurerm_resource_group" "resourcegroup" {
    name = var.rg_name
    //location = var.location
}

/*module "subnet1" {
  source = "./subnet"
  subnet_name = "db_subnet"
  address_prefix = "10.1.3.0/27"
} */

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


