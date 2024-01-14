terraform {
  backend "gcs" {
    bucket = "cloudgeeks-terraform-2"
    prefix = "terraform/state/gke"
  }
}
