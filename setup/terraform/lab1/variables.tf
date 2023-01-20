variable "project_id" {
  description = "Your GCP Project ID."
  type        = string
}

variable "region" {
  type    = string
  default = "us-east1"
}

variable "zone" {
  type    = string
  default = "us-east1-b"
}

variable "container_name" {
    type = string
    default = "krattan/legacy-api-demo:v3"
}
