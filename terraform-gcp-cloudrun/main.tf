provider "google" {
  project = var.project_id
  region  = var.region
}


# enable the API

resource "google_project_service" "cloud_run_api" {
  project = var.project_id
  service = "run.googleapis.com"
  disable_on_destroy = false 
}
variable "create_repo" {
  type    = bool
  default = true
}

resource "google_project_service" "artifact_registry_api" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
  disable_on_destroy = false 
}

# artifact repository
resource "google_artifact_registry_repository" "docker_repo" {
  count         = var.create_repo ? 1 : 0
  project       = var.project_id
  location      = var.region 
  repository_id = var.artifact_registry_repo_name
  format        = "DOCKER" 

  depends_on = [google_project_service.artifact_registry_api]
}

# Cloud Run

resource "google_cloud_run_service" "service"{
  project  = var.project_id
  location = var.region
  name     = var.service_name

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = tostring(var.min_instances)
        "autoscaling.knative.dev/maxScale" = tostring(var.max_instances)
      }
    }

    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repo_name}/${var.image_name}"

        ports {
          container_port = var.container_port
        }
      }
    }
  }
  # route 100% of traffic to the latest ready revision
  traffic {
    percent = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.cloud_run_api,
    google_artifact_registry_repository.docker_repo,
  ]
}

# I AM
resource "google_cloud_run_service_iam_member" "allow_unauthenticated" {
  project  = var.project_id
  location = var.region
  service  = var.service_name
  role     = "roles/run.invoker"
  member   = "allUsers"

  #Check Cloud Run service is created before attempting to set its IAM policy
  depends_on = [google_cloud_run_service.service]
}

terraform {
  backend "remote" {}
}

