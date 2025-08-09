variable "project_id" {
  description = "The GCP project ID where resources will be deployed."
  type        = string
}

variable "region" {
  description = "The GCP region for the Cloud Run service and Artifact Registry."
  type        = string
}

variable "function_name" {
  description = "The name of the Cloud Run service."
   default = "contact-api-fn"
}

variable "entry_point"{
  description = "The name of the Artifact Registry Docker repository."
  default = "app"
}

variable "source_dir" {
  description = "The name and tag of the Docker image."
  default = "../"
}


variable "frontend_origin" {
  type        = string
  description = "Allowed CORS origin"
}




variable "mongodb_uri" {
  type        = string
  description = "MongoDB URI"
}


variable "function_zip_name" {
  description = "Name of the Cloud Function zip archive file"
  type        = string
}

variable "function_zip_path" {
  description = "Relative path to the Cloud Function zip archive file"
  type        = string
}



