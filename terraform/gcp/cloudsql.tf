# Generate random password if not provided
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Cloud SQL Instance
resource "google_sql_database_instance" "main" {
  name             = var.db_instance_name
  database_version = var.db_version
  region           = var.region

  settings {
    tier              = var.db_tier
    availability_type = "ZONAL"  # Use REGIONAL for high availability
    disk_size         = 10
    disk_type         = "PD_SSD"
    disk_autoresize   = true

    backup_configuration {
      enabled            = true
      start_time         = "03:00"
      point_in_time_recovery_enabled = false
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = 7
      }
    }

    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.vpc.id
      require_ssl     = false

      authorized_networks {
        name  = "all"
        value = "0.0.0.0/0"  # Restrict this in production
      }
    }

    maintenance_window {
      day          = 7  # Sunday
      hour         = 3
      update_track = "stable"
    }

    database_flags {
      name  = "max_connections"
      value = "100"
    }
  }

  deletion_protection = false  # Set to true in production
}

# Database
resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.main.name
}

# Database user
resource "google_sql_user" "user" {
  name     = var.db_user
  instance = google_sql_database_instance.main.name
  password = var.db_password != "" ? var.db_password : random_password.db_password.result
}

# Service Networking Connection for Private IP
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = []
}
