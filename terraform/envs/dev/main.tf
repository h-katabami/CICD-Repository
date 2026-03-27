provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

module "state_backend" {
  source = "../../modules/state-backend"

  state_bucket_name = var.state_bucket_name
  github_org        = var.github_org
  github_repo       = var.github_repo
  deploy_role_name  = var.deploy_role_name
  deploy_policy_name = var.deploy_policy_name
  oidc_sub          = var.oidc_sub
  create_github_oidc_provider = var.create_github_oidc_provider
}
