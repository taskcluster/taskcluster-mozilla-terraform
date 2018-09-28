##
# Similar to https://gist.github.com/djmitche/80353576a0f389bf130bcb439f63d070
signin-aws() {
    # reset any existing credentials
    unset AWS_SESSION_TOKEN
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_ACCESS_KEY_ID

    # Expiration time of login session (in seconds)
    DURATION="21600"  # 6 hours

    # Ask user for token
    if [[ -z "$TOKEN" ]]; then
      echo -n "Enter AWS MFA token: "
      read TOKEN
    fi

    # Re-export AWS credentials for use in this script, if set
    if [ -n "$SIGNIN_AWS_ACCESS_KEY_ID" ]; then
        export AWS_ACCESS_KEY_ID="$SIGNIN_AWS_ACCESS_KEY_ID"
        export AWS_SECRET_ACCESS_KEY="$SIGNIN_AWS_SECRET_ACCESS_KEY"
    fi

    msg info "Fetching temporary AWS credentials"

    SERIAL_NUMBER=`aws "${@}" iam list-mfa-devices  | jq -r .MFADevices[0].SerialNumber`
    if [ -z "$SERIAL_NUMBER" ]; then
      echo "Could not list MFA devices"
      return 1
    fi
    STS_CREDENTIALS=`aws "${@}" sts get-session-token --serial-number "$SERIAL_NUMBER" --token-code "$TOKEN" --duration-seconds $DURATION`
    if [ -z "$STS_CREDENTIALS" ]; then
      echo "Could not get session token"
      return 1
    fi

    export AWS_ACCESS_KEY_ID=`echo $STS_CREDENTIALS | jq -r .Credentials.AccessKeyId`
    export AWS_SECRET_ACCESS_KEY=`echo $STS_CREDENTIALS | jq -r .Credentials.SecretAccessKey`
    export AWS_SESSION_TOKEN=`echo $STS_CREDENTIALS | jq -r .Credentials.SessionToken`
}

setup-aws() {
    if [ ! -d ~/.aws ]; then
        msg warning 'AWS is not set up; running `aws configure`..'
        msg info "Enter credentials for the AWS account associated with ${DEPLOYMENT}"
        aws configure
    fi
    if ! aws s3 ls >/dev/null 2>/dev/null; then
        msg warning 'AWS MFA required'
        signin-aws || return 1
    fi

    # sanity check this is the correct account
    local got_account=$(aws sts get-caller-identity | jq -r .Account)
    if [ "${got_account}" != "${TF_VAR_aws_account}" ]; then
        msg warn "Those AWS credentials are for the wrong AWS account!"
        rm -rf ~/.aws
        setup-aws
        return
    fi

    msg info 'AWS credential setup complete'

    # now try to create the resources Terraform needs for its state, if not already done
    local bucket="${DPL}-tfstate"
    msg debug "Checking for Terraform state bucket ${bucket}"
    if ! aws s3 ls "s3://${bucket}" 2>/dev/null >/dev/null; then
        msg info "Creating Terraform state bucket ${bucket}"
        aws s3 mb "s3://${bucket}" --region "${TF_VAR_aws_region}"
        # note that terraform can adopt this without 'terraform import'
    fi

    local terraform_dir
    for terraform_dir in setup install; do
        local table="${DPL}-tfstate-${terraform_dir}"
        msg debug "Checking for Terraform state DynamoDB table ${table}"
        if ! aws dynamodb describe-table --region "${TF_VAR_aws_region}" --table-name "${table}" >/dev/null 2>/dev/null; then
            msg info "Creating Terraform state DynamoDB table ${table}"
            aws dynamodb create-table \
                --table-name "${table}" \
                --region "${TF_VAR_aws_region}" \
                --attribute-definitions AttributeName=LockID,AttributeType=S \
                --key-schema AttributeName=LockID,KeyType=HASH \
                --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 >/dev/null || \
                msg error failed to create table
            msg warn "you must run the following in ${terraform_dir}:"
            msg warn " terraform import aws_dynamodb_table.dynamodb_tfstate_lock ${DPL}-tfstate-${terraform_dir}"
        fi
    done
}
