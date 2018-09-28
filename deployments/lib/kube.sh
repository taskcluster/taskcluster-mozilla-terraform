setup-kube() {
    msg info "Setting gcloud project"
    # note that this will succeed even if the project does not exist
    gcloud config set project "$TF_VAR_gcp_project"
    
    msg info "Getting kubectl context"
    gcloud container clusters get-credentials \
        "$TF_VAR_kubernetes_cluster_name" \
        --region "$TF_VAR_gcp_region" >/dev/null 2>/dev/null
    if [ $? != 0 ]; then
        msg warning 'Could not initialize kubectl context; if this is because it is not created yet,'
        msg warning 'just run `setup` again when it has been created.'
    fi
}
