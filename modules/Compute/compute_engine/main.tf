resource "google_compute_instance" "ubuntu_instance" {
  name                      = var.instance_name
  machine_type              = var.machine_type
  zone                      = var.zone
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = var.image
      size  = 10
      type  = "pd-balanced"
    }
  }
  tags = var.network_tags
  network_interface {
    network    = var.vpc_network_self_link
    subnetwork = var.subnetwork_self_link
  }

}
