#!/bin/bash

bash ./setup_env.sh

WORKING_DIR="$(dirname $(readlink -f $0))"
export WORKING_DIR="${WORKING_DIR/\/Deployment*/}"
export CONF_FILE="${WORKING_DIR}/Deployment/scripts/variables.conf"
export HCL_FILE="${WORKING_DIR}/Deployment/terraform/backend.hcl"
export VAR_FILE="${WORKING_DIR}/Deployment/terraform/terraform.tfvars"

set -a
source ${CONF_FILE}
set +a

export S3_KEY="terraform/${ENVIRONMENT}/${STACK_ID}/terraform-state.tfstate"

cd ${WORKING_DIR}/Deployment/terraform

generate_aws_credential(){
  # Assume role to use AWS CLI, this prevents using user credentials directly
  if [[ -z "${AWS_SESSION_TOKEN}" && -z "${AWS_ROLE_ARN}" ]]; then
    echo '============='
    echo "Please provider AWS_SESSION_TOKEN or AWS_ROLE_ARN!"
    echo '============='
    exit 1
  else
    if [ -n "${AWS_ROLE_ARN}" ]; then
      aws sts assume-role --role-arn ${AWS_ROLE_ARN} --duration-seconds 3600 --role-session-name jenkins_sts_assume > ./jenkins_sts_assume.txt
      if [ $? -eq 0 ]; then
        export AWS_SECRET_ACCESS_KEY=$(cat ./jenkins_sts_assume.txt | jq ".Credentials.SecretAccessKey" -r)
        export AWS_ACCESS_KEY_ID=$(cat ./jenkins_sts_assume.txt | jq ".Credentials.AccessKeyId" -r)
        export AWS_SESSION_TOKEN=$(cat ./jenkins_sts_assume.txt | jq ".Credentials.SessionToken" -r)
        export AWS_SESSION_EXPIRATION=$(cat ./jenkins_sts_assume.txt | jq ".Credentials.Expiration" -r)
        rm -f ./jenkins_sts_assume.txt
      else
        export AWS_SESSION_EXPIRATION=$(date --date="-6 hours ago" -u +"%Y-%m-%dT%TZ")
      fi
    fi
  fi
}

verify_bucket(){
    # Check whether bucket exists
    aws s3api head-bucket --bucket "${S3_BUCKET}" 2>/dev/null
    if [ "$?" -gt 0 ];then
      # Create new bucket
      if [ "${AWS_REGION}" != "us-east-1" ];then
        aws s3api create-bucket --acl private \
                                --bucket "${S3_BUCKET}" \
                                --create-bucket-configuration LocationConstraint="${AWS_REGION}" || error_hanlding 'creating new bucket'
      else
        aws s3api create-bucket --acl private \
                                --bucket "${S3_BUCKET}" || error_hanlding 'creating new bucket'
      fi
      # Block public access
      aws s3api put-public-access-block --bucket "${S3_BUCKET}" \
                                --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
    fi
    # Grant READ/WRITE Log Delivery permission
    CHECK_WRITE="$(aws s3api get-bucket-acl --bucket "${S3_BUCKET}" | jq '.Grants[] | select (.Grantee.URI == "http://acs.amazonaws.com/groups/s3/LogDelivery" and .Permission == "WRITE")')"
    if [ -z "${CHECK_WRITE}" ];then
      POLICY="$(aws s3api get-bucket-acl --bucket "${S3_BUCKET}" | jq '.Grants += [{"Grantee": { "Type": "Group", "URI": "http://acs.amazonaws.com/groups/s3/LogDelivery"}, "Permission": "WRITE"}]')"
      aws s3api put-bucket-acl --bucket "${S3_BUCKET}" \
                               --access-control-policy "${POLICY}"
    fi
    CHECK_READ_ACP="$(aws s3api get-bucket-acl --bucket "${S3_BUCKET}" | jq '.Grants[] | select (.Grantee.URI == "http://acs.amazonaws.com/groups/s3/LogDelivery" and .Permission == "READ_ACP")')"
    if [ -z "${CHECK_WRITE}" ];then
      POLICY="$(aws s3api get-bucket-acl --bucket "${S3_BUCKET}" | jq '.Grants += [{"Grantee": {"Type": "Group","URI": "http://acs.amazonaws.com/groups/s3/LogDelivery"}, "Permission": "READ_ACP"}]')"
      aws s3api put-bucket-acl --bucket "${S3_BUCKET}" \
                               --access-control-policy "${POLICY}"
    fi
}

generate_var_file(){
  # Generate Terraform tfvars file by substituting the environment variables
  envsubst < "${VAR_FILE}.env" > "${VAR_FILE}"
}

generate_hcl_file(){
  # Generate Terraform HCK backend file
  cat > $HCL_FILE<<EOF
bucket = "${S3_BUCKET}"
key    = "${S3_KEY}"
region = "${AWS_REGION}"
EOF
}

terraform_actions(){
  terraform init -no-color -backend-config="${HCL_FILE}" || error_hanlding 'initialing Terraform'
  if [ "${ACTION}" == 'SETUP' ];then
    terraform plan -no-color -var-file="${VAR_FILE}" || error_hanlding 'planning for Terraform'
    terraform apply -no-color -auto-approve -var-file="${VAR_FILE}" || error_hanlding 'creating new Terraform resources'
  elif [ "${ACTION}" == 'DESTROY' ];then
    terraform plan -no-color -destroy -var-file="${VAR_FILE}" || error_hanlding 'planning for Terraform'
    terraform destroy -no-color -auto-approve -var-file="${VAR_FILE}" || error_hanlding 'destroying Terraform resources'
  fi
}

error_hanlding(){
  MESSAGE=$1
  echo '================'
  echo "Error during ${MESSAGE}!"
  exit 1
}

generate_aws_credential
verify_bucket
generate_var_file
generate_hcl_file
terraform_actions