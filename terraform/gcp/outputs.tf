output "project_id" {
  description = "GCP project ID"
  value       = var.project_id
}

output "region" {
  description = "GCP region"
  value       = var.region
}

output "vpc_id" {
  description = "VPC ID"
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "VPC name"
  value       = google_compute_network.vpc.name
}

output "subnet_id" {
  description = "Subnet ID"
  value       = google_compute_subnetwork.subnet.id
}

output "gke_cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.primary.name
}

output "gke_cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "gke_cluster_ca_certificate" {
  description = "GKE cluster CA certificate"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "storage_bucket_app_data" {
  description = "Cloud Storage bucket for app data"
  value       = google_storage_bucket.app_data.name
}

output "storage_bucket_backups" {
  description = "Cloud Storage bucket for backups"
  value       = google_storage_bucket.backups.name
}

output "storage_bucket_terraform_state" {
  description = "Cloud Storage bucket for Terraform state"
  value       = google_storage_bucket.terraform_state.name
}

output "sql_instance_name" {
  description = "Cloud SQL instance name"
  value       = google_sql_database_instance.main.name
}

output "sql_instance_connection_name" {
  description = "Cloud SQL instance connection name"
  value       = google_sql_database_instance.main.connection_name
}

output "sql_instance_ip_address" {
  description = "Cloud SQL instance IP address"
  value       = google_sql_database_instance.main.public_ip_address
}

output "sql_database_name" {
  description = "Database name"
  value       = google_sql_database.database.name
}

output "sql_user_name" {
  description = "Database user name"
  value       = google_sql_user.user.name
  sensitive   = true
}

output "sql_user_password" {
  description = "Database user password"
  value       = var.db_password != "" ? var.db_password : random_password.db_password.result
  sensitive   = true
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone ${var.zone} --project ${var.project_id}"
}
