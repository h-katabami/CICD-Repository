aws_region        = "ap-northeast-1"
state_bucket_name_dev  = "cicd-state-dev"
state_bucket_name_prod = "cicd-state-prod"

github_org  = "development-t"
github_repo = "twilio-flow-custom-parts-kawagoe-city"

enabled_environments = ["dev", "prod"]

deploy_role_name_dev  = "gha-terraform-deploy-dev"
deploy_role_name_prod = "gha-terraform-deploy-prod"
