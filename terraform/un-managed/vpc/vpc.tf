resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Define public subnets
resource "google_compute_subnetwork" "public_subnet_1" {
  name          = "public-subnet-1"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.10.0.0/16"
}

resource "google_compute_subnetwork" "public_subnet_2" {
  name          = "public-subnet-2"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.11.0.0/16"
}

resource "google_compute_subnetwork" "public_subnet_3" {
  name          = "public-subnet-3"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.12.0.0/16"
}

# Define private subnets
resource "google_compute_subnetwork" "private_subnet_1" {
  name          = "private-subnet-1"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "20.20.0.0/16"
}

resource "google_compute_subnetwork" "private_subnet_2" {
  name          = "private-subnet-2"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "20.21.0.0/16"
}

resource "google_compute_subnetwork" "private_subnet_3" {
  name          = "private-subnet-3"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "20.22.0.0/16"
}

# Cloud Router for NAT
resource "google_compute_router" "router" {
  name    = "nat-router"
  region  = "us-central1"
  network = google_compute_network.vpc_network.name
}

# Cloud NAT for private subnets
resource "google_compute_router_nat" "nat" {
  name                               = "nat-gateway"
  router                             = google_compute_router.router.name
  region                             = "us-central1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.private_subnet_1.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  subnetwork {
    name                    = google_compute_subnetwork.private_subnet_2.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  subnetwork {
    name                    = google_compute_subnetwork.private_subnet_3.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}