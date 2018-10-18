output "root_access_token" {
  sensitive = true
  value     = "${module.taskcluster.root_access_token}"
}

output "cluster_ip" {
  value = "${data.kubernetes_service.deployment_endpoint.load_balancer_ingress.0.ip}"
}
