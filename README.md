# Taskcluster Mozilla Terraform

This is the Taskcluster team's internal terraform configuration for setting up
the team's clusters. It uses [taskcluster-terraform](https://github.com/taskcluster/taskcluster-terraform) to do most of the work. This is a good project to cargo-cult if you
wish to set up your own cluster.

## Prerequisites

To run terraform, you will need:

* Docker
* Configured passwordstore access to team secrets
* AWS credentials
* Azure credentials
* A Google Cloud account

## Usage

Because of the peculiar configuration of terraform used here, the supported way to apply the configuration in the repository is to run terraform in the provided docker image.
To do so, run

```shell
./terraform-runner.sh <deployment>
```

where `<deployment>` is the name of the deployment you want to address (e.g., `taskcluster-staging`).
This will do a fancy dance to set up access to all of the cloud services, and so on.
Just follow its instructions.
You will need to extract the appropriate secrets file for the deployment from the team passwordstore repository, and paste that into `~/secrets.sh` when directed to do so.

Most of the credentials (including these secrets) are cached from run to run in a docker volume, limiting the amount of logging-in you will need to do.

*CAUTION*: that docker volume thus contains powerful cleartext secrets!
Docker volumes are readable by anyone with permission to execute `docker run` on a host.
**DO NOT RUN THIS TOOL ON A SHARED OR UNTRUSTED SYSTEM**

Once setup is complete, the script drops you in a shell at `/repo`.
That's a bind mount of the repository where you ran `./terraform-runner.sh`.
You can run `terraform` as much as you'd like in that docker container.
You can also use the `kubectl`, `gcloud`, `az`, and `aws` tools from this environment to examine and administer the cluster.

You must install submodules with `git submodule init` and `git submodule update`. If you wish to udpate to a newer version of the remote, add `--remote` to the second command.

All other work (editing files, etc.) should occur outside of the docker container, as usual.

### Existing Deployments

If a deployment has already been set up, and you just want to modify it, change to the `install` directory.
The first time around, you will need to run `terraform init` to install all of the various modules.
Once that succeeds, `terraform plan` and `terraform apply` as usual.

### New Deployments

If a deployment has not been set up, it will not have a Google Cloud
configuration yet.  In this case, run `terraform init` and `terraform apply` in
the `setup` directory.

Once that has completed successfully, edit `terraform-runner.sh` appropriately
to add configuration for the new deployment and re-run it.  Make a push to this
repository to update the script with the new configuration.


## Docker Build

To build the docker image, run `./build.sh`.
Note that this image is completely nondeterministic and will pull the latest version of everything.
Caveat ædificator.
