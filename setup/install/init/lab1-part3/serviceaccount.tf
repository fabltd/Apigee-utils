resource "google_service_account" "gateway" {
  account_id   = "gatewaysa"
  display_name = "Gateway Service Account"
}