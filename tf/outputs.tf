output "root_access_token" {
  sensitive = true
  value     = "${module.taskcluster.root_access_token}"
}

output "websocktunnel_secret" {
  sensitive = true
  value     = "${module.taskcluster.websocktunnel_secret}"
}

output "cluster_ip" {
  value = "${module.taskcluster.cluster_ip}"
}

output "cluster_url" {
  value = "${var.root_url}"
}
