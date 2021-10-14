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