//ingress rule that allows traffic from the client netork

resource "google_compute_firewall" "allow_web" {
  name = "allow_website_traffic"
  description = "allow app traffic from client"
  priority = 9000
  direction = "INGRESS"
  network  = "global/networks/vpc-network"
  source_ranges = ["11.100.0.1/32"] //some specific range on client nw
  target_tags = "web-traffic" // to select specific vms
  enable_logging = true
  disabled = false
  allow {
      ip_protocol = "tcp"
      ports = ["8000"] // app is running on custom port
    }
}

//ingress rule that allows traffic from the Google Cloud health checking systems

resource "google_compute_firewall" "allow_health_check" {
  name          = "fw-allow-health-check"
  direction     = "INGRESS"
  disabled      = false
  network       = "global/networks/vpc-network"
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["allow-health-check"]
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
}
