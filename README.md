Notes for now:

* `. <(pass terraform/taskcluster-mozilla-terraform.sh)`
* Get aws creds with `aws-signin`
* Get azure creds with `az login`
* Get gce creds with `gcloud auth application-default login`

Note: You may need to follow [these instructions](https://www.terraform.io/docs/providers/azurerm/authenticating_via_azure_cli.html) to set the default azure account

To get secrets out:
```
terraform output -json | jq '.taskcluster_installer_config.value' > <taskcluster-installer>/terraform.json
```
