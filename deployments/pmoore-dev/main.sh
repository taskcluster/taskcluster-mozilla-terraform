export DPL=pmooredev

setup-variables() {
    setup-common-variables

    export TF_VAR_aws_account="710952102342"
    export TF_VAR_notify_ses_arn="arn:aws:ses:us-east-1:710952102342:identity/taskcluster-staging-noreply@mozilla.com"

    export TF_VAR_rabbitmq_hostname="hip-macaw.rmq.cloudamqp.com"
    export TF_VAR_rabbitmq_admin_username="pvigqwpo"
    export TF_VAR_rabbitmq_password="$(get-secret rabbitmq_password)"

    export TF_VAR_root_url="https://pmoore.taskcluster-dev.net"

    export TF_VAR_irc_name="taskcluster|pmoore"
    export TF_VAR_irc_nick="taskcluster|pmoore"
    export TF_VAR_irc_port=6697
    export TF_VAR_irc_real_name="Taskcluster (Pete Moore)"
    export TF_VAR_irc_server="irc.mozilla.org"
    export TF_VAR_irc_password="$(get-secret irc_password)"

    export TF_VAR_github_integration_id=1270
    export TF_VAR_github_oauth_token="$(get-secret github_oauth_token)"
    export TF_VAR_github_webhook_secret="$(get-secret github_webhook_secret)"
    export TF_VAR_github_private_pem="$(get-secret github_private_pem)"
}
