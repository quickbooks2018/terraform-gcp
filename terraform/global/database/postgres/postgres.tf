module "postgresql" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "20.0.0"

  project_id        = var.project_id
  name              = var.db_name
  database_version  = var.database_version
  region            = var.region
  disk_size         = var.disk_size
  disk_type         = var.disk_type
  disk_autoresize   = var.disk_autoresize
  availability_type = var.availability_type
  edition           = var.edition
  tier              = var.tier

  deletion_protection = true

  backup_configuration = {
    enabled                        = true
    start_time                     = "03:00"
    point_in_time_recovery_enabled = true
    transaction_log_retention_days = 7
    backup_retention_settings = {
      retained_backups = 7
    }
  }

  ip_configuration = {
    ipv4_enabled                                  = false // Ensure no public IP
    require_ssl                                   = true
    enable_private_path_for_google_cloud_services = true
    private_network                               = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/networks/${var.vpc_name}"
    authorized_networks                           = []
  }

  additional_users = [
    {
      name            = var.db_user
      password        = var.db_password
      random_password = false
    }
  ]
}
