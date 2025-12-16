# Generate random password if not provided
resource "random_password" "sql_admin_password" {
  length  = 16
  special = true
}

# SQL Server
resource "azurerm_mssql_server" "main" {
  name                         = "${var.project_name}-sqlserver"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password != "" ? var.sql_admin_password : random_password.sql_admin_password.result
  
  minimum_tls_version = "1.2"

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# SQL Database
resource "azurerm_mssql_database" "main" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Firewall rule to allow Azure services
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "allow-azure-services"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Firewall rule for AKS subnet
resource "azurerm_mssql_virtual_network_rule" "aks_subnet" {
  name      = "aks-subnet-rule"
  server_id = azurerm_mssql_server.main.id
  subnet_id = azurerm_subnet.main[0].id
}
