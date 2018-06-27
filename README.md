# Taskcluster Mozilla Terraform

This is the Taskcluster team's internal terraform configuration for setting up
the team's clusters. It uses [taskcluster-terraform](https://github.com/taskcluster/taskcluster-terraform) to do most of the work. This is a good project to cargo-cult if you
wish to set up your own cluster.

## Prereqs

Install the AWS CLI (`aws`), the Azure CLI (`az`), the Google Cloud SDK (`gcloud`) and Kubectl (`kubectl`).

* `. <(pass terraform/taskcluster-mozilla-terraform.sh)`
* Activate AWS creds with `signin-aws --profile <profile>`
* Activate Azure creds with `az account get-access-token`

We use the same Azure and GCE credentials for all deployments, so you should not need to change those.
We use different AWS accounts, so ensure you've selected the right profile for the cluster you wish to apply these settings to.

### Account Setup

The first time, you may need to set up CLI access to all these accounts..

#### AWS

Set up credentials for AWS using `aws configure --profile <profile>`.
Use [signin-aws](https://gist.github.com/djmitche/80353576a0f389bf130bcb439f63d070) to support signin with an MFA code.
See [Named Profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html) for advice on setting up multiple AWS profiles.

#### Azure

The `az login` command will do the initial setup for the Azure account.
Signin with the shared Azure account.
Note that this is considered a "personal" account, not business.

**Note: You may need to follow [these instructions](https://www.terraform.io/docs/providers/azurerm/authenticating_via_azure_cli.html) to set the default azure account**

#### GCE

Activate GCE creds with `gcloud auth application-default login`.

Unless you are going to set up the cluster from scratch (see below), run

```shell
gcloud container clusters get-credentials taskcluster --zone <cluster master zone> --project $TF_VAR_gce_project
```

to create a kubectl context.
The project environment variable here was sourced from `terraform/taskcluster-mozilla-terraform.sh`.
The cluster master zone is available in the gcloud console.

### Terraform Setup

Terraform must be built from source, along with a few providers.

```shell
mkdir go
export GOPATH="$PWD/go"
PATH="$PWD/go/bin:$PATH"
go version   # needs to be go 1.10.x (don't pay attention to terraform repo's minimum version)
go get github.com/hashicorp/terraform
go get golang.org/x/tools/cmd/stringer
( cd $GOPATH/src/github.com/hashicorp/terraform && make dev )
```

And install the providers:

```shell
go get -u github.com/ericchiang/terraform-provider-k8s
go get -u github.com/taskcluster/terraform-provider-jsone
```

Note that in any new shells, you will need to set the PATH again:
```shell
PATH="$PWD/go/bin:$PATH"
```

## Usage

On the first run of this only, you _must_ first create the kubernetes cluster by:

1. In the `setup` directory, you should `../go/bin/terraform init` and `../go/bin/terraform apply`. This will create
a cluster and allow us to move onto the following steps.

If you have not yet configured your cluster in kubeconfig or you have set a different default
cluster context, you can prepare for the following steps.

2. `kubectl config get-contexts`
3. `kubectl config use-context <cluster context>` -- select the context matching the gcloud cluster from the `get-contexts` list
4. `kubectl create clusterrolebinding cluster-admin-binding-<your username> --clusterrole cluster-admin --user $(gcloud config get-value account)`

Now the final step is all you may need to do on a normal day if you have already done the previous things.

1. Go to the `install` directory and `../go/bin/terraform init` followed by `../go/bin/terraform apply`. This will use your configured kubectl to create resources in your cluster.
2. Automatically set up cluster-admin-binding stuff. Probably end up with service account for tf instead of users login?
