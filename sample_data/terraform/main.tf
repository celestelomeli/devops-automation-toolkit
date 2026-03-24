terraform {
  required_version = ">= 1.0.0"

  # required_providers {
  #   aws = {
  #     source  = "hashicorp/aws"
  #     version = "~> 5.0"
  #   }
  # }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "devops-toolkit"
}

locals {
  environment = "dev"
  project_tag = "${var.project_name}-${local.environment}"
}

output "project_tag" {
  value       = local.project_tag
  description = "Combined project and environment tag"
}
