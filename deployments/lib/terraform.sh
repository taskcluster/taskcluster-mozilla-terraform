setup-terraform() {
    mkdir -p /home/tf/dot-terraform
    touch /home/tf/terraform-backend.tf
    touch /home/tf/providers.tf

    msg info "Creating tf/terraform-backend.tf file"
    sed -e "s/<DPL>/${DPL}/" -e "s/<REGION>/${TF_VAR_aws_region}/" \
        < /repo/tf/terraform-backend.tf.in \
        > /repo/tf/terraform-backend.tf

    msg info "Creating tf/providers.tf file"
    python /repo/deployments/lib/providers-sub.py \
        < /repo/tf/providers.tf.in \
        > /repo/tf/providers.tf
}
