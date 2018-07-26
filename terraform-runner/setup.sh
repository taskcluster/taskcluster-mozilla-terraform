#! /bin/bash

# display a message at a particular level
msg() {
    local level="${1}"
    shift

    local _esc=$'\033'
    local normal="$_esc[0m"

    case $level in
        # don't display debug messages unless DEBUG is set
        debug) [ -z "$DEBUG" ] && return ;;
        info) local color="$_esc[0;36m" ;;
        warning) local color="$_esc[1;33m" ;;
        error) local color="$_esc[1;31m" ;;
    esac

    echo "$color${@}$normal"
}

msg info "Setting up credentials to run taskcluster-mozilla-terraform for $DEPLOYMENT"
msg info "  -- run '. /setup.sh' if necessary to repeat this setup process"

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

### Passwordstore

# the terraform-runner.sh script dumps secrets at ~/secrets.sh, so read that if it exists,
# but remove it immediately.  If it does not exist but there are TF_VAR variables set,
# that's OK.
if [ -f "/home/tf/secrets.sh" ]; then
    msg info "Sourcing secrets.sh"
    source "/home/tf/secrets.sh"
else
    msg info "secrets.sh not found"
fi

tf_vars=$(python -c 'import os, sys; sys.stdout.write(" ".join(v for v in os.environ if v.startswith("TF_VAR_")))')
if [ -z "$tf_vars" ]; then
    msg error 'No TF_VAR secrets are set!'
    echo "Put the required terraform variables in /home/tf/secrets.sh in this container; easiest is to simply"
    echo "copy-paste the data from your secret storage."
    return 1
fi

### Azure

if [ ! -d ~/.azure ]; then
    msg warning 'Azure login required'
    az login
else
    msg info 'Refreshing Azure credentials'
    az account get-access-token | \
        python -c 'import json, sys; print("  Token expires " + json.load(sys.stdin)["expiresOn"])'
fi
msg info 'Azure setup complete'

### AWS

if [ ! -d ~/.aws ]; then
    msg warning 'AWS is not set up; running `aws configure`..'
    aws configure
fi
if ! aws s3 ls >/dev/null 2>/dev/null; then
    msg warning 'AWS MFA required'
    signin-aws || return 1
fi
msg info 'AWS setup complete'

### Google Cloud

if ! gcloud auth print-access-token >/dev/null 2>/dev/null; then
    msg warning 'Google Cloud login required'
    gcloud auth login
fi
if ! gcloud auth application-default print-access-token >/dev/null 2>/dev/null; then
    msg warning 'Google Cloud ADC login required (yes, sorry, two logins)'
    gcloud auth application-default login
fi
msg info 'Google Cloud setup complete'

### Kubernetes

if [ -n "$GCLOUD_PROJECT" ]; then
    if ! kubectl get pods >/dev/null 2>&1; then
        msg debug "setting gcloud project"
        gcloud config set project "$GCLOUD_PROJECT"
        msg debug "getting kubectl context"
        gcloud container clusters get-credentials "$GCLOUD_CLUSTER" --zone "$GCLOUD_CLUSTER_ZONE"
        # TODO: not sure what to do with the clusterrolebinding??
    fi
    msg info 'kubectl context setup complete'
else
    msg warning 'No deployment-specific config defined in terraform-runner.sh; not setting up kubectl'
fi
