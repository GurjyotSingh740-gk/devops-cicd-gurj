variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "app_port" {
  description = "External port for the application"
  type        = number
  default     = 8081
}
