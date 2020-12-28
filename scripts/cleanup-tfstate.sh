#!/usr/bin/env bash

# This script will be triggered upon running `terragrunt destroy` to cleanup the deleted tfstate from S3 bucket and Dynamodb

NOFORMAT='\033[0m'
BOLD='\033[1m'
YELLOW='\033[0;33m'

AWS_REGION="$1"
S3_BUCKET="$2"
DYNAMODB="$3"
TFSTATE_PATH="$4"
TG_PATH="$5"

printf '%b%bCleaning up terraform state [%s] from [%s]\n\n' "${BOLD}" "${YELLOW}" "${TFSTATE_PATH}" "${S3_BUCKET}"

# Delete state from S3 bucket
aws s3 rm s3://"${S3_BUCKET}"/"${TFSTATE_PATH}"

# Delete state from dynamodb
aws dynamodb delete-item --region "${AWS_REGION}" --table-name "${DYNAMODB}" \
    --key '{ "LockID": { "S": "'"${S3_BUCKET}"'/'"${TFSTATE_PATH}"'-md5" } }'

# Delete local terragrunt cache folder
find "$TG_PATH" -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;

printf 'Cleaning terraform state is completed%b\n' "${NOFORMAT}"
