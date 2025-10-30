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

# Prometheus Container
resource "docker_image" "prometheus" {
  name = "prom/prometheus:latest"
}

resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = docker_image.prometheus.image_id

  ports {
    internal = 9090
    external = 9091  # Changed to 9091
  }

  volumes {
    host_path      = "${path.module}/prometheus"
    container_path = "/etc/prometheus"
  }

  restart = "unless-stopped"
}

# cAdvisor Container
resource "docker_image" "cadvisor" {
  name = "gcr.io/cadvisor/cadvisor:latest"
}

resource "docker_container" "cadvisor" {
  name  = "cadvisor"
  image = docker_image.cadvisor.image_id

  ports {
    internal = 8080
    external = 8085  # Changed to 8085
  }

  volumes {
    host_path      = "/"
    container_path = "/rootfs"
    read_only      = true
  }
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
    read_only      = true
  }
  volumes {
    host_path      = "/sys"
    container_path = "/sys"
    read_only      = true
  }
  volumes {
    host_path      = "/var/lib/docker"
    container_path = "/var/lib/docker"
    read_only      = true
  }

  restart = "unless-stopped"
}

