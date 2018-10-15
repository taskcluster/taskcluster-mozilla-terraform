setup-common-variables() {
    # pass DEPLOYMENT and DPL along to Terraform directly
    export TF_VAR_deployment="${DEPLOYMENT}"
    export TF_VAR_dpl="${DPL}"

    # -- the remainder are defaults and can be overridden per deployment --

    ## AWS

    export TF_VAR_aws_region="us-east-1"

    ## Azure

    export TF_VAR_azure_region="eastus"

    ## GCP

    export TF_VAR_gcp_billing_account_id="$(get-secret gcp_billing_account_id)"
    export TF_VAR_gcp_project="${DEPLOYMENT}"
    export TF_VAR_gcp_region="us-east1"
    export TF_VAR_gcp_folder_id="944037250603"

    ## RabbitMQ

    export TF_VAR_rabbitmq_vhost="${DPL}"

    ## Kubernetes

    export TF_VAR_kubernetes_cluster_name=taskcluster
    export TF_VAR_kubernetes_nodes=2  # default

    ## Mozilla

    export TF_VAR_secops_cloudtrail="0"
    export TF_VAR_secops_cloudtrail_bucket=""

    ## Taskcluster

    export TF_VAR_cluster_name="${DEPLOYMENT}"
}

check-variables() {
    if [ "${TF_VAR_root_url%%/}" != "${TF_VAR_root_url}" ]; then
        msg error "Root URL (${TF_VAR_root_url}) ends in a slash -- that's not allowed"
    fi
}
