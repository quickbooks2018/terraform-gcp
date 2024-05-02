terraform {
  backend "gcs" {
    bucket = "cloudgeeks-terraform"
    prefix = "terraform/state/global/databases/postgresql-01"
  }
}
