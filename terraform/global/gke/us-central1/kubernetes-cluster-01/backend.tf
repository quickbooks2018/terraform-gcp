terraform {
  backend "gcs" {
    bucket = "cloudgeeks-terraform-4"
    prefix = "terraform/state/gke"
  }
}
