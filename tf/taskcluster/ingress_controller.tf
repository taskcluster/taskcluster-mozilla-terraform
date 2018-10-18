data "jsone_template" "ingress_controller_namespace" {
  template = "${file("${path.module}/ingress_controller/namespace.yaml")}"
}

resource "k8s_manifest" "ingress_controller_namespace" {
  content = "${data.jsone_template.ingress_controller_namespace.rendered}"
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

data "jsone_template" "ingress_controller_serviceaccount" {
  template = "${file("${path.module}/ingress_controller/serviceaccount.yaml")}"
}

resource "k8s_manifest" "ingress_controller_serviceaccount" {
  content    = "${data.jsone_template.ingress_controller_serviceaccount.rendered}"
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

##
# Certificate Management with Cert-Manager (LetsEncrypt)
#
# This must be in the same namespace as the ingress controller, so that
# the ingress controller can access the TLS secret.

# set up an ingress for cert-manager to manage

data "jsone_template" "certificate_challenge_ingress" {
  template = "${file("${path.module}/ingress_controller/ingress.yaml")}"

  context = {
    root_url = "${var.root_url}"
  }
}

resource "k8s_manifest" "certificate_challenge_ingress" {
  content    = "${data.jsone_template.certificate_challenge_ingress.rendered}"
  depends_on = ["k8s_manifest.ingress_controller_namespace"]

  lifecycle {
    # cert-manager will modify this out from under us, so ignore those changes
    ignore_changes = ["content"]
  }
}

# a ClusterIssuer to issue certificates

data "jsone_template" "certificate_clusterissuer" {
  template = "${file("${path.module}/ingress_controller/clusterissuer.yaml")}"
}

resource "k8s_manifest" "certificate_clusterissuer" {
  content = "${data.jsone_template.certificate_clusterissuer.rendered}"

  depends_on = [
    "k8s_manifest.cert_manager_clusterissuer_crd",
    "k8s_manifest.ingress_controller_namespace",
  ]
}

# ..and the certificate itself

data "jsone_template" "ingress_controller_certificate" {
  template = "${file("${path.module}/ingress_controller/certificate.yaml")}"

  context = {
    root_url = "${var.root_url}"
  }
}

resource "k8s_manifest" "ingress_controller_certificate" {
  content = "${data.jsone_template.ingress_controller_certificate.rendered}"

  depends_on = [
    "k8s_manifest.cert_manager_clusterissuer_crd",
    "k8s_manifest.ingress_controller_namespace",
  ]
}
