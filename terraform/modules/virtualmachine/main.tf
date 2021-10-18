resource "azurerm_network_interface" "nic_app" {
  name                = "${var.appvm_name}-nic01"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "virtualmachine_web" {
  name                  = var.webvm_name
  location              = var.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  network_interface_ids = [azurerm_network_interface.nic_web.id]
  vm_size               = "Standard_D2_v2"


  storage_image_reference {
  id = "/subscriptions/f28c99ba-3eac-470a-a3ee-fa026a3302d3/resourceGroups/gesos-prd/providers/Microsoft.Compute/galleries/gesos_image_central/images/GESOS-AZ-BASE-CENTOS7" 
  }

  storage_os_disk {
    name              = "osdiskweb"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    
  }
  os_profile {
    computer_name  = var.webvm_name
    admin_username = "azureuser"
    admin_password = ""
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  
  tags = {
        environment = var.environment
        application = var.application
        owner = var.owner
        uai = var.uai
  }
}
