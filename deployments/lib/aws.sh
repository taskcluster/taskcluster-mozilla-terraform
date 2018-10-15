##
# Similar to https://gist.github.com/djmitche/80353576a0f389bf130bcb439f63d070
signin-aws() {
    local duration serial_number sts_credentials token
    # reset any existing credentials
    unset AWS_SESSION_TOKEN
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_ACCESS_KEY_ID

    # Expiration time of login session (in seconds)
    duration="21600"  # 6 hours

    # Ask user for token
    echo -n "Enter AWS MFA token: "
    read token

    msg info "Fetching temporary AWS credentials"

    serial_number=`aws "${@}" iam list-mfa-devices  | jq -r .MFADevices[0].SerialNumber`
    if [ -z "$serial_number" ]; then
      echo "Could not list MFA devices"
      return 1
    fi
    sts_credentials=`aws "${@}" sts get-session-token --serial-number "$serial_number" --token-code "$token" --duration-seconds $duration`
    if [ -z "$sts_credentials" ]; then
      echo "Could not get session token"
      return 1
    fi

    export AWS_ACCESS_KEY_ID=`echo $sts_credentials | jq -r .Credentials.AccessKeyId`
    export AWS_SECRET_ACCESS_KEY=`echo $sts_credentials | jq -r .Credentials.SecretAccessKey`
    export AWS_SESSION_TOKEN=`echo $sts_credentials | jq -r .Credentials.SessionToken`
}

setup-aws() {
    local creds_file=~/.aws-sts-creds.sh

    if [ ! -d ~/.aws ]; then
        msg warning 'AWS is not set up; running `aws configure`..'
        msg info "Enter credentials for the AWS account associated with ${DEPLOYMENT}"
        msg info "Region and output format can be left at their default."
        aws configure
    fi

    # try to load existing creds
    if [ -f $creds_file ]; then
        source $creds_file
    fi

    while ! aws s3 ls >/dev/null 2>/dev/null; do
        msg warning 'AWS MFA required'
        signin-aws
    done

    # sanity check this is the correct account
    local got_account=$(aws sts get-caller-identity | jq -r .Account)
    if [ "${got_account}" != "${TF_VAR_aws_account}" ]; then
        msg warn "Those AWS credentials are for the wrong AWS account!"
        rm -rf ~/.aws
        setup-aws
        return
    fi

    # write out new creds for next time
    echo "export AWS_ACCESS_KEY_ID='$AWS_ACCESS_KEY_ID'" > $creds_file
    echo "export AWS_SECRET_ACCESS_KEY='$AWS_SECRET_ACCESS_KEY'" >> $creds_file
    echo "export AWS_SESSION_TOKEN='$AWS_SESSION_TOKEN'" >> $creds_file

    msg info 'AWS credential setup complete'

    # now try to create the resources Terraform needs for its state, if not already done
    local bucket="${DPL}-tfstate"
    msg debug "Checking for Terraform state bucket ${bucket}"
    if ! aws s3 ls "s3://${bucket}" 2>/dev/null >/dev/null; then
        msg info "Creating Terraform state bucket ${bucket}"
        aws s3 mb "s3://${bucket}" --region "${TF_VAR_aws_region}"
        # note that terraform can adopt this without 'terraform import'
    fi

    local table="${DPL}-tfstate"
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
        msg warn "you must run the following in tf/ to import the state management:"
        msg warn " terraform import aws_dynamodb_table.dynamodb_tfstate_lock ${table}"
    fi
}
