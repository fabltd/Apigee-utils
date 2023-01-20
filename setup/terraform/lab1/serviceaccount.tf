resource "google_service_account" "default" {
  account_id   = "legacyapi"
  display_name = "Legacy API Service Account"
}

resource "google_project_iam_member" "firestore_owner_binding" {
  project = var.project_id
  role    = "roles/datastore.owner"
  member  = "serviceAccount:${google_service_account.default.email}"
  depends_on = [google_service_account.default]
}