terraform {
  backend "gcs" {
    bucket = "cloudgeeks-terraform-4"
    prefix = "terraform/state/global/vpc/nat"
  }
}
