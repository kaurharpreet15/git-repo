terraform {
    required_providers {
    azurerm = {
    version = "1.37"
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

data "azurerm_route_table" "gert" {
  name                = var.rt_name
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

resource "azurerm_network_security_group" "nsg" {
    name = var.nsg_name
    resource_group_name = azurerm_resource_group.resourcegroup.name
    location = var.location

tags = {
        environment = var.environment
        application = var.application
        owner = var.owner
        uai = var.uai
  }
}

resource "azurerm_subnet" "subnet" {
    depends_on = [azurerm_network_security_group.nsg]
    name = var.subnet_name
    resource_group_name = var.vnet_rg_name
    virtual_network_name = var.vnet_name
    address_prefix = var.address_prefix
    network_security_group_id = azurerm_network_security_group.nsg.id
    route_table_id = data.azurerm_route_table.gert.id
}

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

resource "azurerm_network_interface" "nic_web" {
  name                = "${var.webvm_name}-nic01"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "testconfiguration2"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic_db" {
  name                = "${var.dbvm_name}-nic01"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "testconfiguration3"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "virtualmachine_app" {
  name                  = var.appvm_name
  location              = var.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  network_interface_ids = [azurerm_network_interface.nic_app.id]
  vm_size               = "Standard_D2_v2"


  storage_image_reference {
  id = "/subscriptions/f28c99ba-3eac-470a-a3ee-fa026a3302d3/resourceGroups/gesos-prd/providers/Microsoft.Compute/galleries/gesos_image_central/images/GESOS-AZ-BASE-WINDOWS2016"
  }
  
  storage_os_disk {
    name              = "osdiskapp"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
      }
  os_profile {
    computer_name  = "NCLRBWROGAPP"
    admin_username = "azureuser"
    admin_password = "azur3_U53r01"
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
  
  tags = {
        environment = var.environment
        application = var.application
        owner = var.owner
        uai = var.uai
  }
}
resource "azurerm_virtual_machine" "virtualmachine_db" {
  name                  = var.dbvm_name
  location              = var.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  network_interface_ids = [azurerm_network_interface.nic_db.id]
  vm_size               = "Standard_E2_v3"


  storage_image_reference {
  id = "/subscriptions/f28c99ba-3eac-470a-a3ee-fa026a3302d3/resourceGroups/gesos-prd/providers/Microsoft.Compute/galleries/gesos_image_central/images/GESOS-AZ-BASE-ORACLELINUX8"
  }

  storage_os_disk {
    name = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    
  }
  os_profile {
    computer_name  = var.dbvm_name
    admin_username = "azureuser"
    admin_password = "azur3_U53r01"
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
    admin_password = "azur3_U53r01"
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


resource "azurerm_lb" "ilb" {
  name                = var.loadbalancer_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  frontend_ip_configuration {
    name                 = "frontend_ip_config"
    subnet_id            = azurerm_subnet.subnet.id
    //private_ip_address_version = "IPV4"
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_lb_backend_address_pool" "bpl" {
  resource_group_name = azurerm_resource_group.resourcegroup.name
  loadbalancer_id = azurerm_lb.ilb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "bplasso" {
  network_interface_id    = azurerm_network_interface.nic_web.id
  ip_configuration_name   = "testconfiguration2"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bpl.id
}

resource "azurerm_lb_probe" "probe1" {
  resource_group_name = azurerm_resource_group.resourcegroup.name
  loadbalancer_id     = azurerm_lb.ilb.id
  name                = "http"
  protocol            = "TCP"
  port                = 80
}

resource "azurerm_lb_probe" "probe2" {
  resource_group_name = azurerm_resource_group.resourcegroup.name
  loadbalancer_id     = azurerm_lb.ilb.id
  name                = "https"
  protocol            = "TCP"
  port                = 443
}

resource "azurerm_lb_rule" "ilbrule1" {
  resource_group_name = azurerm_resource_group.resourcegroup.name
  loadbalancer_id     = azurerm_lb.ilb.id
  name                           = "LBRule1"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend_ip_config"
  enable_floating_ip             = false
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bpl.id
  idle_timeout_in_minutes        = 5
  probe_id                       = azurerm_lb_probe.probe1.id
}

resource "azurerm_lb_rule" "ilbrule2" {
  resource_group_name = azurerm_resource_group.resourcegroup.name
  loadbalancer_id     = azurerm_lb.ilb.id
  name                           = "LBRule2"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "frontend_ip_config"
  enable_floating_ip             = false
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bpl.id
  idle_timeout_in_minutes        = 5
  probe_id                       = azurerm_lb_probe.probe2.id
}