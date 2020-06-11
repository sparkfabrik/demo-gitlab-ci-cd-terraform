variable "project_id" {
  description = "The project ID to host the cluster in"
  default = "deltatre-demo-webinar-cicd"
}

variable "cluster_name" {
  description = "The default cluster name"
  default     = "d3-webinar-cluster"
}

variable "region" {
  description = "The region to host the cluster in"
  default = "europe-west1"
}

variable "zones" {
  type        = list(string)
  description = "The zone to host the cluster in (required if is a zonal cluster)"
  default = [
      "europe-west1-b"
  ]
}
