setup-azure() {
    local ok=false
    if [ -d ~/.azure ]; then
        msg info 'Refreshing Azure credentials'
        az account get-access-token >/dev/null 2>&1
        [ "$?" = 0 ] && ok=true
    fi

    if ! $ok; then
        msg warning 'Azure login required'
        msg info "Login to the Azure account associated with ${DEPLOYMENT}, then follow the link below"
        az login
    fi
    msg info 'Azure setup complete'
}
