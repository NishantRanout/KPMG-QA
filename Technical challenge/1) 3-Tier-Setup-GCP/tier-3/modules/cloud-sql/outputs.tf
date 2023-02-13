output "instance_name" {
  value       = "${google_sql_database_instance.default.name}"
  description = "The instance name for the master instance"
}

output "instance_address" {
  value       = "${google_sql_database_instance.default.ip_address}"
  description = "The IPv4 addesses assigned for the master instance"
}

output "instance_connection_name" {
  value       = "${google_sql_database_instance.default.connection_name}"
  description = "The connection name of the master instance to be used in connection strings"
}
