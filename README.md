# cicd-repo

Kawagoe などの案件で共通利用する CI/CD 用リポジトリです。  
このフォルダはローカル実装用で、GitHub へは未発行のまま利用できます。

## 含まれるもの

- `terraform/state-backend`: Terraform の state 管理基盤（S3 + GitHub OIDC ロール）
- `.github/workflows/reusable-terraform-deploy.yml`: Lambda ビルド + Terraform apply の再利用ワークフロー

state ファイルは 1 つの S3 バケットに集約し、以下のキー構成を使います。

- `state/<repository-name>/<env>/terraform.tfstate`

## 使い方（最小）

1. `terraform/state-backend/terraform.tfvars.example` を元に値を設定
2. `terraform init && terraform apply` で state 基盤を作成
3. 既存案件リポジトリ（例: kawagoe）から reusable workflow を呼び出す、またはワークフロー内容をコピーして利用

`terraform/state-backend` 自体は backend を持っていないため、この Terraform の state はローカル管理です。

## Kawagoe での初回利用手順

1. `terraform/state-backend/terraform.tfvars.example` を `terraform/state-backend/terraform.tfvars` にコピー
2. `github_org` を GitHub の owner 名に変更
3. `github_repo` は `twilio-flow-custom-parts-kawagoe-city` のまま利用
4. `state_bucket_name` は一意な S3 バケット名へ変更
5. `enabled_environments` に今回作る環境だけを指定
6. `terraform/state-backend` で `terraform init` と `terraform apply` を実行
7. 出力された `terraform_state_bucket`, `aws_role_arn_dev`, `aws_role_arn_prod` を必要な分だけ案件リポジトリの Variables/Secrets に登録

## 前提

- GitHub Actions OIDC を使うため、対象リポジトリとブランチを IAM 信頼ポリシーに登録
- state バケット名はグローバルで一意
