terraform {
  backend "gcs" {
    bucket = "cloudgeeks-terraform"
    prefix = "terraform/state/global/vpc/nat"
  }
}
