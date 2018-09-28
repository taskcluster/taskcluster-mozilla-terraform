setup-terraform() {
    msg info "Creating terraform-backend.tf files"
    for terraform in setup install; do
        sed -e "s/<DPL>/${DPL}/" -e "s/<REGION>/${TF_VAR_aws_region}/" \
            < $terraform/terraform-backend.tf.in \
            > $terraform/terraform-backend.tf
    done
}
