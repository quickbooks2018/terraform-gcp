resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Define public subnets
resource "google_compute_subnetwork" "public_subnet_1" {
  name          = "${var.public_subnet_name}-1"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = var.public_subnet_cidr_1
}

resource "google_compute_subnetwork" "public_subnet_2" {
  name          = "${var.public_subnet_name}-2"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = var.public_subnet_cidr_2
}

resource "google_compute_subnetwork" "public_subnet_3" {
  name          = "${var.public_subnet_name}-3"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = var.public_subnet_cidr_3
}

# Define private subnets
resource "google_compute_subnetwork" "private_subnet_1" {
  name          = "${var.private_subnet_name}-1"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = var.private_subnet_cidr_1
}

resource "google_compute_subnetwork" "private_subnet_2" {
  name          = "${var.private_subnet_name}-2"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = var.private_subnet_cidr_2
}

resource "google_compute_subnetwork" "private_subnet_3" {
  name          = "${var.private_subnet_name}-3"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = var.private_subnet_cidr_3
}

# Cloud Router for NAT
resource "google_compute_router" "router" {
  name    = var.nat_router_name
  region  = var.region
  network = google_compute_network.vpc_network.name
}

# Cloud NAT for private subnets
resource "google_compute_router_nat" "nat" {
  name                               = "${var.nat_router_name}-gateway"
  router                             = google_compute_router.router.name
  region                             = var.region
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
