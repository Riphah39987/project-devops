# Generate random suffix for unique bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Cloud Storage Bucket for application data
resource "google_storage_bucket" "app_data" {
  name          = "${var.project_name}-app-data-${random_id.bucket_suffix.hex}"
  location      = var.region
  force_destroy = false
  
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }

  labels = {
    environment = var.environment
    project     = var.project_name
  }
}

# Cloud Storage Bucket for backups
resource "google_storage_bucket" "backups" {
  name          = "${var.project_name}-backups-${random_id.bucket_suffix.hex}"
  location      = var.region
  force_destroy = false
  
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 90
    }
  }

  labels = {
    environment = var.environment
    project     = var.project_name
  }
}

# Cloud Storage Bucket for Terraform state
resource "google_storage_bucket" "terraform_state" {
  name          = "${var.project_name}-terraform-state-${random_id.bucket_suffix.hex}"
  location      = var.region
  force_destroy = false
  
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  labels = {
    environment = var.environment
    project     = var.project_name
  }
}
