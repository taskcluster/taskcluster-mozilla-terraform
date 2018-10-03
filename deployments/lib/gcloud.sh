setup-gcloud() {
    if ! gcloud auth print-access-token >/dev/null 2>/dev/null; then
        msg warning 'Google Cloud login required'
        msg info "Enter credentials for the Google account associated with ${DEPLOYMENT}"
        gcloud auth login
    fi
    if ! gcloud auth application-default print-access-token >/dev/null 2>/dev/null; then
        msg warning 'Google Cloud ADC login required (yes, sorry, two logins)'
        gcloud auth application-default login
    fi
    msg info 'Google Cloud setup complete'
}
