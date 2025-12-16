variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
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

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "devops-vpc"
}

variable "subnet_cidr" {
  description = "Subnet CIDR range"
  type        = string
  default     = "10.2.0.0/24"
}

variable "gke_cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "devops-gke-cluster"
}

variable "gke_node_count" {
  description = "GKE initial node count"
  type        = number
  default     = 2
}

variable "gke_machine_type" {
  description = "GKE node machine type"
  type        = string
  default     = "e2-medium"
}

variable "gke_min_nodes" {
  description = "GKE minimum nodes for autoscaling"
  type        = number
  default     = 1
}

variable "gke_max_nodes" {
  description = "GKE maximum nodes for autoscaling"
  type        = number
  default     = 3
}

variable "db_instance_name" {
  description = "Cloud SQL instance name"
  type        = string
  default     = "devops-postgres-instance"
}

variable "db_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "POSTGRES_15"
}

variable "db_tier" {
  description = "Cloud SQL tier"
  type        = string
  default     = "db-f1-micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "devopsdb"
}

variable "db_user" {
  description = "Database user"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = ""
}
