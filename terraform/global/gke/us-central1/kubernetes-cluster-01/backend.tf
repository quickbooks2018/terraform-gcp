terraform {
  backend "gcs" {
    bucket = "cloudgeeks-terraform"
    prefix = "terraform/state/gke"
  }
}
