//Database
resource "google_sql_database" "database" {
  name     = "my-database"
  instance = google_sql_database_instance.instance.name
}

//Generate a new id each time we build  a new sql instance
resource "random_id" "sql_instance" {
  keepers = {
    sql_instance_name= "${var.sql_instance_name}"
  }
  byte_length = 4
}

//DatabaseInstance
resource "google_sql_database_instance" "instance" {
  project          = var.project_id
  name             = "${var.sql_instance_name}-${random_id.sql_instance.hex}"
  region           = var.region
  database_version = var.database_version

  settings {
    tier = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_type = "PD_SSD"
    tier      = "db-n1-standard-2"
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
      start_time         = "05:00"
    }
  }

  deletion_protection  = "true"
  //private ip range reserved for db instances
  resource "google_compute_global_address" "private_ip_address" {
    name          = "private-ip-address"
    purpose       = "VPC_PEERING"
    address_type  = "INTERNAL"
    prefix_length = 16
    network       = google_compute_network.peering_network.id
  }
  //private service access for db instances
  resource "google_service_networking_connection" "default" {
    network                 = google_compute_network.peering_network.id
    service                 = "servicenetworking.googleapis.com"
    reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  }
}
