output "vpc_network" {
  value = google_compute_network.vpc_network.name
}

output "google_compute_subnetwork_private_subnet_1" {
  value = google_compute_subnetwork.private_subnet_1.name
}