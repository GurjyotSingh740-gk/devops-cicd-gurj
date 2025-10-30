# Configure Terraform
terraform {
  required_version = ">= 1.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Configure Docker provider
provider "docker" {
  host = "npipe:////./pipe/docker_engine"  # For Windows
  # host = "unix:///var/run/docker.sock"   # For Linux/Mac
}

# Docker Image
resource "docker_image" "app_image" {
  name = "devops-app:${var.environment}"
  build {
    context    = "../app"
    dockerfile = "Dockerfile"
  }
}

# Docker Container
resource "docker_container" "app_container" {
  name  = "devops-app-${var.environment}"
  image = docker_image.app_image.image_id

  ports {
    internal = 80
    external = var.app_port
  }

  restart = "unless-stopped"
}

#Grafana Docker Image
resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "grafana" {
  name  = "grafana-monitoring"
  image = docker_image.grafana.image_id

  ports {
    internal = 3000
    external = 3000
  }

  restart = "unless-stopped"
}
