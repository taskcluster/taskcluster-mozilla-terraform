#! /bin/bash

set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "setup.sh must be run inside the terraform-runner docker image"
    exit 1
fi

cd /repo
source util/msg.sh
source deployments/lib/secrets.sh
source deployments/lib/variables.sh
source deployments/lib/terraform.sh
source deployments/lib/aws.sh
source deployments/lib/azure.sh
source deployments/lib/gcloud.sh
source deployments/lib/kube.sh

if [ -z "${DEPLOYMENT}" ] || [ ! -d "deployments/${DEPLOYMENT}" ]; then
    msg error "DEPLOYMENT is not set or not found"
    exit 1
fi

msg info "Setting up credentials to run taskcluster-mozilla-terraform for $DEPLOYMENT"
msg info "  -- run 'setup' if necessary to repeat this setup process"

source deployments/${DEPLOYMENT}/main.sh
if [ -z "${DPL} " ]; then
    msg error "deployments/${DEPLOYMENT}/main.sh did not set DPL"
    exit 1
fi

setup() {
    setup-secrets
    setup-variables  # defined by the deployment
    setup-terraform
    setup-azure
    setup-aws
    setup-gcloud
    setup-kube
}

setup
