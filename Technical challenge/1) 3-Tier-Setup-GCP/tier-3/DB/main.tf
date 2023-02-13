provider "google" {
  project = var.project_id
  region  = var.region
}

module "gcp_sql_db_instance" {

  source                          = "../modules/cloud-sql"
  sql_instance_name               = var.sql_instance_name
  database_version                = "${var.database_version}"
  region                          = var.region
  sql_instance_zone               = var.sql_instance_zone
  project_id                      = "${var.project_id}"
  db_name                         = "${var.sql_default_db_name}"
  disk_size                       = var.sql_db_disk_size
}
