/*data "azurerm_virtual_network" "virtualnetwork" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg_name
}*/

data "azurerm_resource_group" "resourcegroup" {
    name = var.rg_name
    //location = var.location
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic01"
  location            = data.azurerm_resource_group.resourcegroup.location
  resource_group_name = data.azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     =  data.azurerm_subnet.subnet.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "random_password" "password" {
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  length           = 16
  special          = true
  override_special = "_%@"
}

data "azurerm_key_vault" "key_vault" {
  count = var.key_vault_id != null ? 0 : 1

  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
}

resource "azurerm_key_vault_secret" "vm_password_key_vault_secret" {
  name            = var.vm_name
  value           = random_password.password.result
  key_vault_id    = data.azurerm_key_vault.key_vault[0].id
}

resource "azurerm_virtual_machine" "virtual_machine" {
  name                  = var.vm_name
  location              = data.azurerm_resource_group.resourcegroup.location
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
  network_interface_ids = [azurerm_network_interface.nic_web.id]
  vm_size               = "Standard_D2_v2"


   source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdiskweb"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    
  }
  os_profile {
    computer_name  = var.vm_name
    admin_username = "azureuser"
    admin_password = random_password.password.result
  }
}
