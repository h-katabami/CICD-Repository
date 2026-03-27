output "terraform_state_bucket" {
  value = aws_s3_bucket.tf_state.bucket
}

output "aws_role_arn" {
  value = aws_iam_role.deploy.arn
}

output "aws_deploy_policy_arn" {
  value = aws_iam_policy.deploy.arn
}

output "github_oidc_provider_arn" {
  value = local.github_oidc_provider_arn
}
