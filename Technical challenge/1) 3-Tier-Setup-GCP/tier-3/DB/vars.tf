variable "project_id" {
  description = "Google Project ID."
  type        = string
}
variable "region" {
  description = "Google Cloud region"
  type        = string
}
variable "sql_instance_name" {
  description = "db instance name"
  type        = string
}

variable "database_version" {}
variable "sql_instance_zone" {}
variable "sql_default_db_name" {}
variable "sql_db_disk_size" {}
