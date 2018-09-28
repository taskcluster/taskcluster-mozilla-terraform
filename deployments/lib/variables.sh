setup-common-variables() {
    # pass DEPLOYMENT and DPL along to Terraform directly
    export TF_VAR_deployment="${DEPLOYMENT}"
    export TF_VAR_dpl="${DPL}"

    ## AWS

    export TF_VAR_taskcluster_bucket_prefix="${DPL}"
    export TF_VAR_aws_region="us-east-1"  # default

    ## Azure

    export TF_VAR_azure_resource_group_name="${DPL}"
    export TF_VAR_azure_region="eastus"  # default

    ## GCP

    export TF_VAR_gce_project="${DEPLOYMENT}"
    export TF_VAR_gce_region="us-east1"  # default

    ## Kubernetes

    export TF_VAR_kubernetes_nodes=2  # default
}
