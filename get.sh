#!/bin/bash
# sets the AWS session with profile
AWS_ACCOUNT=$1
PROFILE=$2
echo " --- account ${AWS_ACCOUNT} -- profile ${PROFILE}"
export VAULT_TOKEN="$(vault write -field=token auth/jwt/login role=${CI_PROJECT_ROOT_NAMESPACE}-aws jwt=$CI_JOB_JWT)" 
export AWS_CREDS="$(vault read -format=json gitlab/${CI_PROJECT_ROOT_NAMESPACE}/aws/creds/${AWS_ACCOUNT}-a${CI_PROJECT_ROOT_NAMESPACE}-developer)"
      
AWS_ACCESS_KEY_ID="$(echo ${AWS_CREDS} | jq -r '.data.access_key')"
AWS_SESSION_TOKEN="$(echo ${AWS_CREDS} | jq -r '.data.security_token')"
AWS_SECRET_ACCESS_KEY="$(echo ${AWS_CREDS} | jq -r '.data.secret_key')"
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID --profile ${PROFILE}
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY --profile ${PROFILE}
aws configure set aws_session_token $AWS_SESSION_TOKEN --profile ${PROFILE}
aws configure set region $AWS_REGION --profile ${PROFILE}
echo "---- profile ${PROFILE} set"
