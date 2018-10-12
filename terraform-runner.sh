#! /bin/bash -e

# cd to repo directory
# cd $(dirname $(readlink -f "$0"))
source util/msg.sh

docker_image="docker.io/taskcluster/terraform-runner:latest@sha256:b6e6afcd61f031c67d82281d14a58fbf6dab9409c4dca4401e93bfefa147e16a"
deployment="$1"

if [ -z "$deployment" ] || [ ! -f terraform-runner.sh ]; then
    msg error "USAGE: ./terraform-runner.sh <deployment>"
    msg info  "  NOTE: set \$PASSWORD_STORE_DIR to point to the TC password store."
    exit 1
fi

if [ ! -d "deployments/${deployment}" ]; then
    msg warn "No such deployment '${deployment}'.  See the README for setting up a new"
    msg warn "deployment, or check the spelling."
    exit 1
fi


# the docker image wants to write to the .terraform directory, so
# make it a link to a directory it can write to.
rm -rf tf/.terraform
ln -s /home/tf/dot-terraform tf/.terraform

# similarly, setup-terraform writes to some tf files, so we
# symlink those to a writeable location
for f in terraform-backend.tf providers.tf; do
    rm -f tf/$f
    ln -s /home/tf/$f tf/$f
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

# and DEBUG, if it's set
if [ -n "${DEBUG}" ]; then
    docker+=(-e DEBUG="${DEBUG}")
fi

# specify the docker image
docker+=($docker_image)

msg info "Starting docker container"
${docker[@]}
