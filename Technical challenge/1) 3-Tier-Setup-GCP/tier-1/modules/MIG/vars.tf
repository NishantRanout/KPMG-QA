variable "project" {
  description = "The project ID to manage the Compute Instance resources"
  type        = string
  }


variable "region" {
  description = "The region for the Compute Instance resources"
  type        = string
  default     = "us-central1"
}

variable "network" {
  description = "Name of the network"
  type        = string
}

variable "instance_template_name" {
  description = "Name of the instance template"
  type        = string
  default     = "webserver-template"
}

variable "instance_name" {
  description = "The machine name to create."
  type        = string
  default     = "web-server"
}

variable "machine_type" {
  description = "The machine type to create."
  type        = string
  default     = "e2-medium"
}

variable "tags" {
  description = "A list of network tags to attach to the instance."
  type        = list(string)
  default     = []
}
