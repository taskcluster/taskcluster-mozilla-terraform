Definition of various deployments we manage

Each has a name, and that name is a subdirectory of this one.
In that directory is a `main.sh`, along with any other desired files.

# Expectations of main.sh

The script should:

* Define `DPL` to be the "short name" for the deployment; this is used to name cloud things to avoid conflicts.
  This should be short and alphabetic (Azure is really picky..)

* Define `setup-variables` which will define any necessary `TF_VAR_` variables.
  This runs *after* `setup-secrets`, so secrets are available and can be explicitly copied into `TF_VAR_` variables.
  Generally this calls the `setup-common-variables` function defined in `deployments/lib/variables.sh`, then applies any deployment-specific customizations.
