output "taskcluster_installer_config" {
  value = "${module.taskcluster.installer_config}"
}

output "auth_root_access_token" {
  sensitive = true
  value = "${module.taskcluster.auth_root_access_token}"
}
