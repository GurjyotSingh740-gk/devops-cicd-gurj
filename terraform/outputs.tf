output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.app_container.id
}

output "app_url" {
  description = "Application URL"
  value       = "http://localhost:${var.app_port}"
}
