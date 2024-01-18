terraform {
  backend "gcs" {
    bucket = "cloudgeeks-terraform-3"
    prefix = "terraform/state/vpc"
  }
}
