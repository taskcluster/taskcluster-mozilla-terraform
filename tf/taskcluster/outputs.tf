output "root_access_token" {
  sensitive = true
  value     = "${module.taskcluster.root_access_token}"
}

output "websocktunnel_secret" {
  sensitive = true
  value     = "${module.taskcluster.websocktunnel_secret}"
}

output "cluster_ip" {
  value = "${data.kubernetes_service.deployment_endpoint.load_balancer_ingress.0.ip}"
}
