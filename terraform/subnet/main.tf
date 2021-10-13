
    resource "azurerm_subnet" "subnet"{
        name = var.subnet_name
        resource_group_name = var.vnet_rg_name
        virtual_network_name = var.vnet_name
        address_prefix = var.address_prefix

    }
