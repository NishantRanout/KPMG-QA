provider "google" {
project = var.project_id
region  = var.region
}

//BaseImage:
resource "google_compute_image" "web-server-image" {
  name = var.imagename
  source_disk = "projects/${var.project_id}/zones/${var.zone}/disks/${var.instance_Name}"
}

module "instance_template" {
  count                = 1
  source               = "../modules/MIG"
}
