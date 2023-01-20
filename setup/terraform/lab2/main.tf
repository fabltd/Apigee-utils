resource "google_compute_instance" "gateway" {
  name         = "gateway"
  machine_type = "e2-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  tags = ["http-server"]

}