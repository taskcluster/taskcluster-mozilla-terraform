declare -A SECRETS

set-secret() {
    msg debug "Setting secret $1"
	SECRETS[$1]="${2}"
}

get-secret() {
	if [ ${SECRETS[$1]+_} ]; then
		echo "${SECRETS[$1]}"
	else
        msg error "Secret $1 not defined"
    fi
}

setup-secrets() {
    if [ -f "/home/tf/secrets.sh" ]; then
        msg info "Sourcing secrets.sh"
        source "/home/tf/secrets.sh"
    else
        msg warning "secrets.sh not found"
        msg info "Please paste the secrets for ${DEPLOYMENT} it now, followed by ^D"
        cat > /home/tf/secrets.sh
        source /home/tf/secrets.sh
    fi
}
