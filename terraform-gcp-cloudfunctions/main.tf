provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "function_source" {
  name     = "${var.project_id}-function-source"
  location = var.region
  force_destroy = true
}
resource "google_storage_bucket_object" "archive" {
  bucket = google_storage_bucket.function_source.name
  name   = var.function_zip_name
  source = data.archive_file.function.output_path
}


resource "google_cloudfunctions2_function" "default" {
  name        = var.function_name
  location    = var.region
  description = "Contact API Flask function"

  build_config {
    runtime     = "python311"
    entry_point = var.entry_point
    source {
      storage_source {
        bucket = google_storage_bucket.function_source.name
        object = google_storage_bucket_object.archive.name
      }
    }
    environment_variables = {
      FRONTEND_ORIGIN = var.frontend_origin
      MONGODB_URI     = var.mongodb_uri
    }
  }

  service_config {
    max_instance_count = 2
    available_memory   = "256M"
    timeout_seconds    = 60
    ingress_settings   = "ALLOW_ALL"
  }

  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.functions.v2.http.v1.HTTP_REQUEST"
    retry_policy   = "RETRY_POLICY_DO_NOT_RETRY"
  }
}

data "archive_file" "function" {
  type        = "zip"
  source_dir  = "${path.module}/.."  # points to contactApi root where main.py lives
  output_path = "${path.module}/../${var.function_zip_name}"
}


