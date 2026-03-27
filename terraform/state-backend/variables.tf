variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "state_bucket_name_dev" {
  type        = string
  description = "Terraform state bucket name for dev"
  default     = null
}

variable "state_bucket_name_prod" {
  type        = string
  description = "Terraform state bucket name for prod"
  default     = null
}

variable "github_org" {
  type        = string
  description = "GitHub organization or user name"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name"
}

variable "enabled_environments" {
  type        = set(string)
  description = "Deployment environments to provision OIDC roles for"
  default     = ["dev"]

  validation {
    condition     = alltrue([for env in var.enabled_environments : contains(["dev", "prod"], env)])
    error_message = "enabled_environments must contain only dev and/or prod."
  }
}

variable "deploy_role_name_dev" {
  type        = string
  description = "IAM role name for dev deployment"
  default     = "gha-terraform-deploy-dev"
}

variable "deploy_role_name_prod" {
  type        = string
  description = "IAM role name for prod deployment"
  default     = "gha-terraform-deploy-prod"
}
