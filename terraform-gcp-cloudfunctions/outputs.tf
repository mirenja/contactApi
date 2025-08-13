##output "function_uri" {
#  value = google_cloudfunctions2_function.default.service_config[0].uri
#}

output "cloud_function_name" {
  value = google_cloudfunctions2_function.default.name
}