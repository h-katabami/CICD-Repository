output "terraform_state_bucket_dev" {
  value = module.state_backend.terraform_state_bucket
}

output "aws_role_arn_dev" {
  value = module.state_backend.aws_role_arn
}

output "aws_deploy_policy_arn_dev" {
  value = module.state_backend.aws_deploy_policy_arn
}

output "github_oidc_provider_arn_dev" {
  value = module.state_backend.github_oidc_provider_arn
}
