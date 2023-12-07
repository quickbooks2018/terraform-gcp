terraform {
  backend "gcs" {
    bucket = "cloudgeeks-terraform-1"
    prefix = "terraform/state/vpc"
  }
}
