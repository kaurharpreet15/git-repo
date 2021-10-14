provider "azurerm" {
    features {}
}

resource "azurerm_network_security_group" "nsg" {
    name = var.nsg_name
    resource_group_name = azurerm_resource_group.resourcegroup.name
    location = var.location
}

resource "azurerm_network_security_group"