
auth_aws_docker() { 
    # WIP
    $REGION = "us-east-2"
    aws ecr get-login-password --region $(REGION) | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com
}



alias front="yarn dev:front"
alias storybook="yarn workspace @oasis/front storybook"
alias yw="yarn workspace"
alias ywf="yarn workspace @oasis/front"
alias pp="pnpm"
alias ppf="pnpm --filter"

export NX_CLOUD_ACCESS_TOKEN="YmVlYTBjNTAtYTcxZi00NjQ0LThlOWItN2QwOTdiMTE3ZmMwfHJlYWQtd3JpdGU="

alias copyfun="cp -R .next/static/ .next/standalone/apps/front/static && cp -R public .next/standalone/apps/front/public"
# noam stuff
alias k-demo='aws eks --region us-east-2 update-kubeconfig --name cloudburst-demo --profile demo'
alias k-staging='aws eks --region us-east-2 update-kubeconfig --name cloudburst-development --role-arn arn:aws:iam::952891650782:role/CloudburstDevelopmentEKSAdmin'
alias k-prod='aws eks update-kubeconfig --region us-east-2 --name cloudburst-prod --role-arn arn:aws:iam::952891650782:role/DeployAdministrator'
alias k-dev='aws eks --region us-east-2 update-kubeconfig --name cloudburst-dev --profile dev'