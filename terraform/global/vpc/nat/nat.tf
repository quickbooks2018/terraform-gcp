# Terraform remote state of the vpc
data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket = "cloudgeeks-terraform-4"
    prefix = "terraform/state/global/vpc"
  }
}


# Cloud Router for NAT
resource "google_compute_router" "router1" {
  name    = "nat-router-us-west1"
  region  = "us-west1"
  network = data.terraform_remote_state.vpc.outputs.vpc.network.network.name
}

# Cloud NAT for private subnet-1
resource "google_compute_router_nat" "nat1" {
  name                               = "us-west1-nat-gateway"
  router                             = google_compute_router.router1.name
  region                             = "us-west1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = "us-west1-private-subnet-01"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

}

# Cloud Router for NAT2
resource "google_compute_router" "router2" {
  name    = "nat-router-us-east1"
  region  = "us-east1"
  network = data.terraform_remote_state.vpc.outputs.vpc.network.network.name
}

# Cloud NAT for private subnet-2
resource "google_compute_router_nat" "nat2" {
  name                               = "us-east1-nat-gateway"
  router                             = google_compute_router.router2.name
  region                             = "us-east1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = "us-east1-private-subnet-02"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

}


# Cloud Router for NAT3
resource "google_compute_router" "router3" {
  name    = "nat-router-us-central1"
  region  = "us-central1"
  network = data.terraform_remote_state.vpc.outputs.vpc.network.network.name
}

# Cloud NAT for private subnet-3
resource "google_compute_router_nat" "nat3" {
  name                               = "us-central-nat-gateway"
  router                             = google_compute_router.router3.name
  region                             = "us-central1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = "us-central1-private-subnet-03"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

}