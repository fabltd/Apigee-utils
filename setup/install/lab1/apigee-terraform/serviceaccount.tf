
resource "google_project_service_identity" "apigee_sa" {
  provider = google-beta
  project  = var.gcp_project_id
  service  = google_project_service.apigee.service
}
