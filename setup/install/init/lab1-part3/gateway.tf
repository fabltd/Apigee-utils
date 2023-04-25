
resource "google_compute_instance" "gateway_vm" {
  name         = "gateway"
  machine_type = "e2-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  service_account {
    email  = google_service_account.gateway.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    network = "mhc-network"
    subnetwork = "mhc-subnetwork"
    access_config {
    }
  }

  tags = ["allow-api-http"] 

}