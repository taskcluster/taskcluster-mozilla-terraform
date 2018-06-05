# Taskcluster Mozilla Terraform

This is the Taskcluster team's internal terraform configuration for setting up
the team's clusters. It uses [taskcluster-terraform](https://github.com/taskcluster/taskcluster-terraform) to do most of the work. This is a good project to cargo-cult if you
wish to set up your own cluster.

## Prereqs

* `. <(pass terraform/taskcluster-mozilla-terraform.sh)`
* Get aws creds with `aws-signin for the proper account`
* Get azure creds with `az login` (Note: You can refresh this with `az account get-access-token`)
* Get gce creds with `gcloud auth application-default login`

You must have kubectl installed.

You must install the [k8s](https://github.com/ericchiang/terraform-provider-k8s) provider to get this to work.

**Note: You may need to follow [these instructions](https://www.terraform.io/docs/providers/azurerm/authenticating_via_azure_cli.html) to set the default azure account**

## Usage

On the first run of this only, you _must_ first create the kubernetes cluster by:

1. In the `setup` directory, you should `terraform init` and `terraform apply`. This will create
a cluster and allow us to move onto the following steps.

If you have not yet configured your cluster in kubeconfig or you have set a different default
cluster context, you can prepare for the following steps.

1. `gcloud container clusters get-credentials <cluster name> --zone <cluster zone> --project <project name>`. Most of these will be available in password store under `terraform/taskcluster-mozilla-terraform.sh`
2. `kubectl config get-contexts`
3. `kubectl config use-context <the correct context you find from the last command>`
4. `kubectl create clusterrolebinding cluster-admin-binding-<your username> --clusterrole cluster-admin --user $(gcloud config get-value account)`

Now the final step is all you may need to do on a normal day if you have already done the previous things.

1. Go to the `install` directory and `terraform init` followed by `terraform apply`. This will use your configured kubectl to create resources in your cluster.
2. Automatically set up cluster-admin-binding stuff. Probably end up with service account for tf instead of users login?
