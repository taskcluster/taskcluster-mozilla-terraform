data "jsone_template" "ingress_controller_namespace" {
  template = "${file("${path.module}/ingress_controller/namespace.yaml")}"
}

resource "k8s_manifest" "ingress_controller_namespace" {
  content = "${data.jsone_template.ingress_controller_namespace.rendered}"
}

data "template_file" "taskcluster_ingress_tls_secret" {
  template = "${file("${path.module}/ingress_controller/taskcluster_ingress_tls_secret.yaml")}"

  vars {
    tls_crt = "${var.root_url_tls_crt}"
    tls_key = "${var.root_url_tls_key}"
  }
}

resource "k8s_manifest" "taskcluster_ingress_tls_secret" {
  content    = "${data.template_file.taskcluster_ingress_tls_secret.rendered}"
  depends_on = ["k8s_manifest.ingress_controller_namespace"]
}

data "jsone_template" "nginx_configuration" {
  template = "${file("${path.module}/ingress_controller/nginx_configuration.yaml")}"
}

resource "k8s_manifest" "nginx_configuration" {
  content    = "${data.jsone_template.nginx_configuration.rendered}"
  depends_on = ["k8s_manifest.ingress_controller_namespace"]
}

data "jsone_template" "tcp_services" {
  template = "${file("${path.module}/ingress_controller/tcp_services.yaml")}"
}

resource "k8s_manifest" "tcp_services" {
  content    = "${data.jsone_template.tcp_services.rendered}"
  depends_on = ["k8s_manifest.ingress_controller_namespace"]
}

data "jsone_template" "udp_services" {
  template = "${file("${path.module}/ingress_controller/udp_services.yaml")}"
}

resource "k8s_manifest" "udp_services" {
  content    = "${data.jsone_template.udp_services.rendered}"
  depends_on = ["k8s_manifest.ingress_controller_namespace"]
}

data "jsone_template" "serviceaccount" {
  template = "${file("${path.module}/ingress_controller/serviceaccount.yaml")}"
}

resource "k8s_manifest" "serviceaccount" {
  content    = "${data.jsone_template.serviceaccount.rendered}"
  depends_on = ["k8s_manifest.ingress_controller_namespace"]
}

data "jsone_template" "clusterrole" {
  template = "${file("${path.module}/ingress_controller/clusterrole.yaml")}"
}

resource "k8s_manifest" "clusterrole" {
  content    = "${data.jsone_template.clusterrole.rendered}"
  depends_on = ["k8s_manifest.ingress_controller_namespace"]
}

data "jsone_template" "role" {
  template = "${file("${path.module}/ingress_controller/role.yaml")}"
}

resource "k8s_manifest" "role" {
  content    = "${data.jsone_template.role.rendered}"
  depends_on = ["k8s_manifest.ingress_controller_namespace"]
}

data "jsone_template" "role_binding" {
  template = "${file("${path.module}/ingress_controller/role_binding.yaml")}"
}

resource "k8s_manifest" "role_binding" {
  content    = "${data.jsone_template.role_binding.rendered}"
  depends_on = ["k8s_manifest.ingress_controller_namespace"]
}

data "jsone_template" "clusterrole_binding" {
  template = "${file("${path.module}/ingress_controller/clusterrole_binding.yaml")}"
}

resource "k8s_manifest" "clusterrole_binding" {
  content    = "${data.jsone_template.clusterrole_binding.rendered}"
  depends_on = ["k8s_manifest.ingress_controller_namespace"]
}

data "jsone_template" "controller" {
  template = "${file("${path.module}/ingress_controller/controller.yaml")}"
}

resource "k8s_manifest" "controller" {
  content    = "${data.jsone_template.controller.rendered}"
  depends_on = ["k8s_manifest.ingress_controller_namespace"]
}

data "jsone_template" "deployment_endpoint" {
  template = "${file("${path.module}/ingress_controller/deployment_endpoint.yaml")}"
}

resource "k8s_manifest" "deployment_endpoint" {
  content    = "${data.jsone_template.deployment_endpoint.rendered}"
  depends_on = ["k8s_manifest.ingress_controller_namespace"]
}

// The following are used to set up an letsencrpypt challenge response
// TODO: Optionally use https://github.com/jetstack/cert-manager to manage certs

data "jsone_template" "acme_ingress" {
  template = "${file("${path.module}/acme_ingress.yaml")}"

  context {
    challenge_key   = "${var.acme_challenge_key}"
    challenge_value = "${var.acme_challenge_value}"
  }
}

resource "k8s_manifest" "acme_ingress" {
  content = "${data.jsone_template.acme_ingress.rendered}"
}
