resource "google_service_account" "default" {
  account_id   = "gateway"
  display_name = "Gateway Service Account"
}