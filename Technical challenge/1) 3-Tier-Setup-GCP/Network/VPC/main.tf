//VPC
resource "google_compute_network" "vpc_network" {
  project                 = "my-project-name"
  name                    = "vpc-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

//subnet
resource "google_compute_subnetwork" "subnet-tier1" {
  name          = "web-subnetwork"
  ip_cidr_range = "10.2.0.0/16" // primary range
  region        = "us-central1"
  network       = google_compute_network.vpc-network.id
  private_ip_google_access = true
  secondary_ip_range {
    range_name    = "test-range"
    ip_cidr_range = "192.168.10.0/24"
  }
}
