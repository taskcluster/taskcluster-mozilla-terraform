setup-terraform() {
    mkdir -p /home/tf/dot-terraform
    touch /home/tf/terraform-backend.tf

    msg info "Creating terraform-backend.tf file"
    sed -e "s/<DPL>/${DPL}/" -e "s/<REGION>/${TF_VAR_aws_region}/" \
        < /repo/tf/terraform-backend.tf.in \
        > /repo/tf/terraform-backend.tf
}
