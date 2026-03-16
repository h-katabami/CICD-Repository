output "terraform_state_bucket" {
  value = aws_s3_bucket.tf_state.bucket
}

output "aws_role_arn_dev" {
  value = aws_iam_role.gha_dev.arn
}

output "aws_role_arn_prod" {
  value = aws_iam_role.gha_prod.arn
}
