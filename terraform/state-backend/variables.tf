variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "state_bucket_name" {
  type        = string
  description = "Terraform state bucket name"
}

variable "github_org" {
  type        = string
  description = "GitHub organization or user name"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name"
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
