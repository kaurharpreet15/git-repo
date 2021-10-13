terraform {
    required_providers {
    azurerm = {
    version = "2.80"
        }
    }
}

provider "azurerm" {
subscription_id = "57ef9ef4-af86-41b4-90bb-deab77ba1d42"
tenant_id = "15ccb6d1-d335-4996-b6f9-7b6925f08121"
client_id = "5ee8be88-c7e4-4a38-a4dd-e3f96ec649fe"
client_secret = "6fc96ddd-a330-4c2d-b8eb-edffce853acd"
}

data "azurerm_virtual_network" "virtualnetwork" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg_name
}


resource "azurerm_resource_group" "resourcegroup" {
    name = var.rg_name
    location = var.location
    tags = {
        environment = var.environment
        application = var.application
        owner = var.owner
        uai = var.uai
    }
}



