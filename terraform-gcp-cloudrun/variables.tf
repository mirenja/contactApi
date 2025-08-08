variable "project_id" {
  description = "The GCP project ID where resources will be deployed."
  type        = string
}

variable "region" {
  description = "The GCP region for the Cloud Run service and Artifact Registry."
  type        = string
}

variable "service_name" {
  description = "The name of the Cloud Run service."
  type        = string
}

variable "artifact_registry_repo_name" {
  description = "The name of the Artifact Registry Docker repository."
  type        = string
}

variable "image_name" {
  description = "The name and tag of the Docker image."
  type        = string
}

variable "container_port" {
  description = "The port your application listens on inside the container."
  type        = number
  default     = 80
}

variable "min_instances" {
  description = "The minimum number of container instances for Cloud Run."
  type        = number
  default     = 2
}

variable "max_instances" {
  description = "The maximum number of container instances for Cloud Run."
  type        = number
  default     = 5
}






