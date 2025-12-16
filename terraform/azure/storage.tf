# Generate random suffix for unique storage account name
resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = "${var.project_name}${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication
  
  blob_properties {
    versioning_enabled = true
    
    delete_retention_policy {
      days = 7
    }
    
    container_delete_retention_policy {
      days = 7
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Blob Container for application data
resource "azurerm_storage_container" "app_data" {
  name                  = "app-data"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Blob Container for backups
resource "azurerm_storage_container" "backups" {
  name                  = "backups"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Blob Container for Terraform state
resource "azurerm_storage_container" "terraform_state" {
  name                  = "terraform-state"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
