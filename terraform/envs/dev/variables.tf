variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile name for this environment"
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

variable "deploy_role_name" {
  type        = string
  description = "IAM role name for deployment"
  default     = "gha-terraform-deploy-dev"
}

variable "deploy_policy_name" {
  type        = string
  description = "IAM policy name for deployment"
  default     = "gha-terraform-deploy-policy-dev"
}

variable "oidc_sub" {
  type        = string
  description = "OIDC sub condition for GitHub Actions token"
  default     = null
}

variable "create_github_oidc_provider" {
  type        = bool
  description = "Whether to create GitHub OIDC provider in this environment"
  default     = true
}
