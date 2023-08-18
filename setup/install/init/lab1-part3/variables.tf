variable "project_id" {
  description = "Your GCP Project ID."
  type        = string
}

variable "region" {
  type    = string
  default = "us-east4"
}

variable "zone" {
  type    = string
  default = "us-east4-c"
}

variable "container_name" {
    type = string
    default = "krattan/legacy-api-demo:v5"
}


