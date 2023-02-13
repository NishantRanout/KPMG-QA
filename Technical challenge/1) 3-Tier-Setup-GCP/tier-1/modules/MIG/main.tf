resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

//instance_template

resource "google_compute_instance_template" "default" {
  name        = var.instance_template_name
  description = "This template is used to create front end web server instances."

  tags = var.tags

  labels = {
    environment = "dev"
  }

  instance_description = "webserver"
  machine_type         = var.machine_type
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // bootdisk
  disk {
    source_image      = "projects/${var.project}/global/images/${var.imagename}"
    auto_delete       = true
    boot              = true
    resource_policies = [google_compute_resource_policy.daily_backup.id]
  }

  network_interface {
    network = var.network
  }

  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
//data-disk
resource "google_compute_disk" "web-data" {
  name  = "existing-data-disk"
  image = data.google_compute_image.my_image.self_link
  size  = 10
  type  = "pd-ssd"
  zone  = "us-central1-a"
  resource_policies = [google_compute_resource_policy.daily_backup.id]
}
//SnapshotPolicyforbothdisk
resource "google_compute_resource_policy" "daily_backup" {
  name   = "every-day-4am"
  region = var.region
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "04:00"
      }
    }
  }
}

//InstanceGroup
resource "google_compute_health_check" "mig-hc" {
  name                = "frontend-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  http_health_check {
    request_path = "/healthz"
    port         = "8080"
  }
}
//Regional MIG
resource "google_compute_region_instance_group_manager" "web" {

  name = "frontend-mig"
  base_instance_name = var.instance_name
  region  = var.region
  distribution_policy_zones = ["us-central1-a", "us-central1-f"]
  depends_on = ["google_compute_instance_template.default"]

  version {
    instance_template = google_compute_instance_template.default.id
  }

  all_instances_config {
    metadata = {
      metadata_key = "metadata_value"
    }
    labels = {
      label_key = "label_value"
    }
  }

  target_pools = [google_compute_target_pool.webserver.id]
  target_size  = 2

  named_port {
    name = "custom"
    port = 8888
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
}
//Autoscaler:
resource "google_compute_autoscaler" "aut" {
  provider = "google"
  project = "${var.project}"
  name   = "web-auto"
  zone   = "${var.zone}"
  depends_on = ["google_compute_instance_group_manager.web"]
  target = "${google_compute_instance_group_manager.web.self_link}"
  autoscaling_policy {
    max_replicas    = 10
    min_replicas    = 5
    cooldown_period = 60
    cpu_utilization {
      target = 0.7
    }
