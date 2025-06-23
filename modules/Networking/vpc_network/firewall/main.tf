resource "google_compute_firewall" "my-vpc-default-allow-internal" {
  name    = "my-vpc-default-allow-internal"
  network = var.vpc_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.private_subnet_app_tag, var.private_subnet_direct_to_vpc_tag]
}

resource "google_compute_firewall" "my-vpc-default-allow-ssh" {
  name    = "my-vpc-default-allow-ssh"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.private_subnet_app_tag, var.private_subnet_direct_to_vpc_tag]
}

resource "google_compute_firewall" "my-vpc-default-allow-rdp" {
  name    = "my-vpc-default-allow-rdp"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.private_subnet_app_tag, var.private_subnet_direct_to_vpc_tag]
}

resource "google_compute_firewall" "my-vpc-default-allow-icmp" {
  name    = "my-vpc-default-allow-icmp"
  network = var.vpc_name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.private_subnet_app_tag, var.private_subnet_direct_to_vpc_tag]
}

