declare -A SECRETS

set-secret() {
    msg debug "Setting secret $1"
	SECRETS[$1]="${2}"
}

get-secret() {
    msg warn "This deployment's main.sh still uses get-secret for $1; update to use set-var-from-secret"
	if [ ${SECRETS[$1]+_} ]; then
		echo "${SECRETS[$1]}"
	else
        msg error "Secret $1 not defined"
    fi
}

set-var-from-secret() {
	if [ ${SECRETS[$1]+_} ]; then
		# quoting in shell is *awesome*!
		eval "$(python -c "import pipes, sys; print('export ' + pipes.quote(sys.argv[1]))" "TF_VAR_$1=${SECRETS[$1]}")"
	else
        msg error "Secret $1 not defined"
        # note that in this case, the TF_VAR_* is not set, so terraform will
        # fail when run
    fi
}

setup-secrets() {
    SECRETS=()
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
