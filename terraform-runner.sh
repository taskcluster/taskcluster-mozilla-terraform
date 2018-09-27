#! /bin/bash -e

docker_image="docker.io/taskcluster/terraform-runner:latest@sha256:349dacf5b65fdaeabf1e2e2bc4eb5d4429f97f18e65dd8d75c6f66f97217842d"
deployment="$1"

if [ -z "$deployment" ] || [ ! -f terraform-runner.sh ]; then
    echo "USAGE: ./terraform-runner.sh <deployment>"
    echo "  NOTE: set \$PASSWORD_STORE_DIR to point to the TC password store."
    exit 1
fi

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

# the docker image wants to write to the .terraform directory, so
# make it a link to a directory it can write to.  Note that these
# directories must be created by the Dockerfile!
for terraform_dir in install setup; do
    rm -rf $terraform_dir/.terraform
    ln -s /home/tf/${terraform_dir}-.terraform $terraform_dir/.terraform
done

## Build a docker create command-line and execute it

declare -a docker
docker=(docker run -ti --rm)

# mount a named volume (named after the deployment) at $HOME; this stores
# all of the dotfiles containing credentials, as well as the terraform modules
# (via the symlinks added above)
docker+=(-v "${deployment}-credentials:/home/tf")
msg warning "CAUTION: docker volume ${deployment}-credentials contains sensitive secrets"

# Mount the current directory (the root of the repo) at /repo.  Note that the
# `z` option in the mount of /repo allows it to work on systems with selinux;
# otherwise the containerized user can't read the directory.
docker+=(-v "$PWD:/repo:z,ro")

# set $DEPLOYMENT for use in setup.sh
docker+=(-e DEPLOYMENT="$deployment")

# add arguments based on the deployment (once that deployment is set up)
case $deployment in
    taskcluster-staging)
        docker+=(-e GCLOUD_PROJECT=taskcluster-staging-214020)
        docker+=(-e GCLOUD_CLUSTER=taskcluster-staging)
        docker+=(-e GCLOUD_CLUSTER_ZONE=us-east4-a)
        ;;
    *)
        msg warning 'No configuration for this deployment; run terraform in the setup directory'
        msg warning '  and edit terraform-runner.sh with the results'
        ;;
esac

# specify the docker image
docker+=($docker_image)

msg info "Running docker container"
${docker[@]}
