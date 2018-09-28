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
    msg info 'AWS setup complete'
}
