export DPL=dustindev

setup-variables() {
    setup-common-variables

    export TF_VAR_aws_account="710952102342"
    export TF_VAR_notify_ses_arn="arn:aws:ses:us-east-1:710952102342:identity/taskcluster-staging-noreply@mozilla.com"

    export TF_VAR_rabbitmq_hostname="hip-macaw.rmq.cloudamqp.com"
    export TF_VAR_rabbitmq_admin_username="pvigqwpo"
    set-var-from-secret rabbitmq_password

    export TF_VAR_gcp_project="dustin-dev-3"

    export TF_VAR_root_url="https://dustin.taskcluster-dev.net"

    export TF_VAR_irc_name="taskcluster|dustin"
    export TF_VAR_irc_nick="taskcluster|dustin"
    export TF_VAR_irc_port=6697
    export TF_VAR_irc_real_name="Taskcluster (Dustin)"
    export TF_VAR_irc_server="irc.mozilla.org"
    set-var-from-secret irc_password

    export TF_VAR_github_app_id=25814
    set-var-from-secret github_webhook_secret
    set-var-from-secret github_private_pem

    export TF_VAR_gce_provider_image_name="taskcluster-generic-worker-debian-9-1545065836"

    set-var-from-secret ui_login_strategies
    export TF_VAR_ui_login_strategy_names="$(echo "${SECRETS[ui_login_strategies]}" | jq -r 'keys | join(" ")')"
}
