clean-variables() {
    # clear all TF_VAR_* exports
    for v in `export | grep TF_VAR_ | cut -d' ' -f 3 | cut -d= -f 1`; do
        eval "unset $v"
    done
}

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

    set-var-from-secret gcp_billing_account_id
    export TF_VAR_gcp_project="${DEPLOYMENT}"
    export TF_VAR_gcp_region="us-east1"
    export TF_VAR_gcp_folder_id="944037250603"

    export TF_VAR_gce_provider_image_name="none"

    ## RabbitMQ

    export TF_VAR_rabbitmq_vhost="${DPL}"

    ## Kubernetes

    export TF_VAR_kubernetes_cluster_name=taskcluster
    export TF_VAR_kubernetes_nodes=1
    export TF_VAR_kubernetes_node_type=n1-standard-4

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
