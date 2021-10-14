provider "azurerm" {
  features {}
}
data "azurerm_resource_group" "resourcegroup" {
    name = var.rg_name
    //location = var.location
}
resource "azurerm_mysql_server" "mysqlserver" {
  name                = var.mysqlserver_name
  location            = data.azurerm_resource_group.resourcegroup.location
  resource_group_name = data.azurerm_resource_group.resourcegroup.name

  administrator_login          = var.adminaccount
  administrator_login_password = var.adminpassword

  sku_name   = var.sku
  storage_mb = var.storage_size
  version    = var.mysqlversion

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "mysqlDB" {
  name                = var.mysqldbname
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
  server_name         = azurerm_mysql_server.mysqlserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}