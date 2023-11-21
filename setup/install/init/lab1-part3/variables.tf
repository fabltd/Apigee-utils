variable "project_id" {
  description = "Your GCP Project ID."
  type        = string
}

variable "region" {
  type    = string
}

variable "zone" {
  type    = string
}

variable "container_name" {
    type = string
    default = "krattan/legacy-api-demo:v5"
}


