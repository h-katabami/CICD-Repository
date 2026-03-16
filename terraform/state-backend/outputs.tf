output "terraform_state_bucket" {
  value = aws_s3_bucket.tf_state.bucket
}

output "aws_role_arn_dev" {
  value = try(aws_iam_role.gha_dev[0].arn, null)
}

output "aws_role_arn_prod" {
  value = try(aws_iam_role.gha_prod[0].arn, null)
}
