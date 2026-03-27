aws_region        = "ap-northeast-1"
aws_profile       = "prod"
state_bucket_name = "cicd-state-prod-353666332910"

github_org  = "development-t"
github_repo = "twilio-flow-custom-parts-kawagoe-city"

deploy_role_name   = "gha-terraform-deploy-prod"
deploy_policy_name = "gha-terraform-deploy-policy-prod"

create_github_oidc_provider = true