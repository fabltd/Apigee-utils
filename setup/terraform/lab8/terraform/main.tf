resource "google_compute_instance" "vs-code-server" {
  name         = "vs-code-server"
  machine_type = "e2-standard-4"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
      type = "pd-ssd"
      size = 64
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

  
}