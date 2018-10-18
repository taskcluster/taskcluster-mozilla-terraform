output "root_access_token" {
  sensitive = true
  value     = "${module.taskcluster.root_access_token}"
}

output "cluster_ip" {
  value = "${module.taskcluster.cluster_ip}"
}

output "cluster_url" {
  value = "${var.root_url}"
}
