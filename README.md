# cicd-repo

Kawagoe などの案件で共通利用する CI/CD 用リポジトリです。  
このフォルダはローカル実装用で、GitHub へは未発行のまま利用できます。

## 含まれるもの

- `terraform/modules/state-backend`: state 管理基盤の共通モジュール（S3 + GitHub OIDC ロール）
- `terraform/envs/dev`: dev 環境用の Terraform ルート
- `terraform/envs/prod`: prod 環境用の Terraform ルート
- `.github/workflows/reusable-terraform-deploy.yml`: Lambda ビルド + Terraform apply の再利用ワークフロー

state ファイルは 1 つの S3 バケットに集約し、以下のキー構成を使います。

- `state/<repository-name>/<env>/terraform.tfstate`

## 使い方（最小）

1. `terraform/envs/dev/terraform.tfvars.example` を元に dev 値を設定
2. `terraform/envs/prod/terraform.tfvars.example` を元に prod 値を設定
3. dev/prod はそれぞれ対応ディレクトリで `terraform init && terraform apply` を実行
4. 既存案件リポジトリ（例: kawagoe）から reusable workflow を呼び出す（`project_suffix` を指定）か、ワークフロー内容をコピーして利用

各ディレクトリは backend を持っていないため、この Terraform の state はローカル管理です。

## Kawagoe での初回利用手順

1. dev 用: `terraform/envs/dev/terraform.tfvars.example` を `terraform/envs/dev/terraform.tfvars` にコピー
2. prod 用: `terraform/envs/prod/terraform.tfvars.example` を `terraform/envs/prod/terraform.tfvars` にコピー
3. `github_org` を GitHub の owner 名に変更
4. `github_repo` は `twilio-flow-custom-parts-kawagoe-city` のまま利用
5. `aws_profile` は dev/prod で対応する AWS CLI profile 名を設定
6. `state_bucket_name` は dev/prod で別の一意な S3 バケット名へ変更
7. dev 側は `terraform/envs/dev`、prod 側は `terraform/envs/prod` で `terraform init` と `terraform apply` を実行
8. dev では `terraform_state_bucket_dev`, `aws_role_arn_dev`、prod では `terraform_state_bucket_prod`, `aws_role_arn_prod` を利用する（固定値を workflow に直書きする運用なら、案件リポジトリの Variables/Secrets 登録は不要）

補足: GitHub OIDC Provider は AWS アカウント内で 1 つだけ作成します。既定では dev 側で作成し、prod 側は既存 Provider を再利用します。

## 実行コマンド例

1. dev plan: `terraform -chdir=terraform/envs/dev plan`
2. prod plan: `terraform -chdir=terraform/envs/prod plan`
3. dev destroy: `terraform -chdir=terraform/envs/dev destroy`
4. prod destroy: `terraform -chdir=terraform/envs/prod destroy`

## 前提

- GitHub Actions OIDC を使うため、対象リポジトリとブランチを IAM 信頼ポリシーに登録
- state バケット名はグローバルで一意
