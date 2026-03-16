provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "tf_state" {
  bucket = var.state_bucket_name
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

locals {
  enable_dev  = contains(var.enabled_environments, "dev")
  enable_prod = contains(var.enabled_environments, "prod")

  oidc_sub_dev  = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/dev"
  oidc_sub_prod = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/prod"
}

data "aws_iam_policy_document" "gha_assume_dev" {
  count = local.enable_dev ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [local.oidc_sub_dev]
    }
  }
}

data "aws_iam_policy_document" "gha_assume_prod" {
  count = local.enable_prod ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [local.oidc_sub_prod]
    }
  }
}

resource "aws_iam_role" "gha_dev" {
  count = local.enable_dev ? 1 : 0

  name               = var.deploy_role_name_dev
  assume_role_policy = data.aws_iam_policy_document.gha_assume_dev[0].json
}

resource "aws_iam_role" "gha_prod" {
  count = local.enable_prod ? 1 : 0

  name               = var.deploy_role_name_prod
  assume_role_policy = data.aws_iam_policy_document.gha_assume_prod[0].json
}

data "aws_iam_policy_document" "deploy_policy" {
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole",
      "iam:GetRole",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:TagRole",
      "iam:UntagRole"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "lambda:*",
      "logs:*",
      "dynamodb:*",
      "s3:*",
      "ssm:*",
      "states:*",
      "events:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "deploy" {
  name   = "gha-terraform-deploy-policy"
  policy = data.aws_iam_policy_document.deploy_policy.json
}

resource "aws_iam_role_policy_attachment" "dev" {
  count = local.enable_dev ? 1 : 0

  role       = aws_iam_role.gha_dev[0].name
  policy_arn = aws_iam_policy.deploy.arn
}

resource "aws_iam_role_policy_attachment" "prod" {
  count = local.enable_prod ? 1 : 0

  role       = aws_iam_role.gha_prod[0].name
  policy_arn = aws_iam_policy.deploy.arn
}
