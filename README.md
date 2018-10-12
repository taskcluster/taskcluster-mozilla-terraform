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

First, don't forget to update submodules.
In the root of this repo, run:

```shell
git submodule init
git submodule update
```

You'll need to re-run the `update` part when git indicates it's out of date.

Because of the peculiar configuration of terraform used here, the supported way to apply the configuration in the repository is to run terraform in the provided docker image.
To do so, run

```shell
./terraform-runner.sh <deployment>
```

where `<deployment>` is the name of the deployment you want to address (e.g., `taskcluster-staging-net`).
This will do a fancy dance to set up access to all of the cloud services, and so on.
Just follow its instructions.
You will need to extract the appropriate secrets file for the deployment from the team passwordstore repository, and paste that in when directed to do so.

Most of the credentials (including these secrets) are cached from run to run in a docker volume, limiting the amount of logging-in you will need to do.

*CAUTION*: that docker volume thus contains powerful cleartext secrets!
Docker volumes are readable by anyone with permission to execute `docker run` on a host.
**DO NOT RUN THIS TOOL ON A SHARED OR UNTRUSTED SYSTEM**!
To delete the volume find it in `docker volume ls` and delete it by name with `docker volume rm`.
You'll need to re-enter all the secret stuff on your next run.

Once setup is complete, the script drops you in a shell at `/repo`.
That's a bind mount of the repository where you ran `./terraform-runner.sh`.
You can run `terraform` as much as you'd like in that docker container.
You can also use the `kubectl`, `gcloud`, `az`, and `aws` tools from this environment to examine and administer the cluster.

All other work (editing files, `git` operations, etc.) should occur outside of the docker container, as usual.
You must install submodules with `git submodule init` and `git submodule update`. If you wish to udpate to a newer version of the remote, add `--remote` to the second command.

### Changing Settings

If you change settings in a deployment configuration file, simply exit the Docker container and re-start it.
Similarly, if your cloud credentials expire, exit the container and re-start it.

If you need to change secrets, you can edit the file within the docker container at `~/secrets.sh`.

If you need to change credentials (perhaps you signed into the wrong AWS account?), follow the `docker volume rm` steps above.

### New Deployments

To create a new deployment, make a new directory under `deployments` and create a `main.sh` there.
See the README in `deployments` for more information.
Ensure that DPL is distinct from any other deployment, or risk creating chaos!

You will also want to create a secrets file in passwordstore, named after your deployment.
You can copy from another one and change the necessary bits.

Then run `./terraform-runner.sh <your-deployment>`.
Enter all the necessary stuff.
In the process, it will tell you to run a `terraform import` command, something like:

```shell
terraform import aws_dynamodb_table.dynamodb_tfstate_lock $DPL-tfstate
```

Once that's done, run `terraform init` and `terraform apply -target module.gke`.
Once that succeeds, proceed with `terraform apply` as for an existing deployment.

This is necessary to set up the GKE environment before trying to create Kubernetes resources.
Terraform's dependencies are not expressive enough to capture this.

#### Common Issues

If you are not already logged into Azure in your browser, the link provided by `terraform-runner.sh` will not work.
Instead, follow the link in passwordstore, login, then follow the link provided by `terraform-runner.sh`.

If you are prompted to accept the Googly terms of service, go to `https://console.cloud.google.com` and do so, then run `terraform` again.
Note that you must be careful to login to the console with your work account -- unlike other Google properties, it is not "sticky".
Firefox multi-account containers are helpful.

If GCP says your project name is already taken, that's a shame -- project ID's are global.
Set `TF_VAR_gcp_project` to something unique, perhaps by appending `-2` to your deployment name.

#### DNS/TLS Setup

Once everything is applied, run

```shell
kubectl get service --namespace ingress-controller deployment-endpoint
```

the "EXTERNAL-IP" field is the IP of your deployment.
It's up to you to configure the DNS for your root URL domain name to point to this IP.

Once you do so, you will find that loading the *http* version of your rootUrl will get you some results.
However, *https* may take some time to start working (and https is technically required, so the cluster won't work correctly until this is done).
The cert-manager service is operating in the background to set up a certificate with LetsEncrypt, and once it does so, https URLs will work and http URLs will redirect to https.

Your deployment is ready to go!

### Existing Deployments

The first time you run terraform for a deployment, you will need to run `terraform init` to install all of the various modules.
Once that succeeds, `terraform plan` and `terraform apply` as usual.
If you have not modified anything in the `gke` module, you can go a little faster by adding `-target module.taskcluster`.

## Terraform-runner Docker Build

To build the docker image, run `./build.sh`.
Note that this image is completely nondeterministic and will pull the latest version of everything.
Caveat ædificator.
