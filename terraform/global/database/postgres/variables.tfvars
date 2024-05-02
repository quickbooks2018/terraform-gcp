project_id = "playground-s-11-9246e05b"
vpc_name   = "terraform-global-vpc"
region     = "us-central1"

database_version  = "POSTGRES_15"
disk_size         = 20
disk_type         = "PD_SSD"
disk_autoresize   = true
availability_type = "REGIONAL" # ZONAL or REGIONAL
edition           = "ENTERPRISE"
tier              = "db-custom-1-3840"

