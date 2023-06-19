
resource "google_compute_instance" "gateway_vm" {
  name         = "gateway"
  machine_type = "e2-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20230616"
    }
  }

  service_account {
    email  = google_service_account.gateway.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = google_compute_subnetwork.mhc-subnet.name
    access_config {
    }
  }

  tags = ["allow-api-http"] 

}