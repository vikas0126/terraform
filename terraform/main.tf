provider "google" {
  project = "practice1-430917"
  region  = "asia-south1"
}

resource "google_compute_network" "vpc_network" {
  name                    = "instance-test2"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "instance-test-pub2"
  ip_cidr_range = "10.142.1.0/24"
  network       = google_compute_network.vpc_network.self_link
  region        = "asia-south1"
}

resource "google_compute_instance" "vm_instance" {
  count        = 3
  name         = "my-vm-instance-${count.index + 1}"
  machine_type = "e2-small"
  zone         = "asia-south1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2404-noble-amd64-v20240806"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link
    access_config {
      // Ephemeral IP
    }
  }
}
