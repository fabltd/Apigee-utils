resource "google_service_account" "default" {
  account_id   = "vs-code-server"
  display_name = "Vs Code Service Account"
}