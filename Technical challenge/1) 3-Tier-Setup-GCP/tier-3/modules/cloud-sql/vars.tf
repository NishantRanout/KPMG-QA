variable "project_id" {
  description = "The project ID to manage the Cloud SQL resources"
}

variable "sql_instance_name" {
  description = "The name of the Cloud SQL resources"
}

variable "database_version" {
  description = "The database version to use"
  default = "MYSQL_8_0"
}

variable "region" {
  description = "The region of the Cloud SQL resources"
  default     = "europe-north1"
}
