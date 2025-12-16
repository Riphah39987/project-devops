variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "devops-multicloud"
}

variable "vnet_address_space" {
  description = "Address space for VNet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "subnet_prefixes" {
  description = "Subnet address prefixes"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "subnet_names" {
  description = "Subnet names"
  type        = list(string)
  default     = ["subnet-1", "subnet-2"]
}

variable "aks_cluster_name" {
  description = "AKS cluster name"
  type        = string
  default     = "devops-aks-cluster"
}

variable "aks_dns_prefix" {
  description = "AKS DNS prefix"
  type        = string
  default     = "devopsaks"
}

variable "aks_node_count" {
  description = "AKS node count"
  type        = number
  default     = 2
}

variable "aks_node_vm_size" {
  description = "AKS node VM size"
  type        = string
  default     = "Standard_B2s"
}

variable "sql_admin_username" {
  description = "SQL Server admin username"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "SQL Server admin password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "sql_database_name" {
  description = "SQL Database name"
  type        = string
  default     = "devopsdb"
}

variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}
