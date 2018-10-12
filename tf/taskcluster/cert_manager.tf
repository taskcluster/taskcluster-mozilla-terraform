# Install cert-manager; equivalent to
# https://raw.githubusercontent.com/jetstack/cert-manager/v0.5.0/contrib/manifests/cert-manager/with-rbac.yaml

data "jsone_template" "cert_manager_namespace" {
  template = "${file("${path.module}/cert_manager/namespace.yaml")}"
}

resource "k8s_manifest" "cert_manager_namespace" {
  content = "${data.jsone_template.cert_manager_namespace.rendered}"
}

data "jsone_template" "cert_manager_serviceaccount" {
  template = "${file("${path.module}/cert_manager/serviceaccount.yaml")}"
}

resource "k8s_manifest" "cert_manager_serviceaccount" {
  content    = "${data.jsone_template.cert_manager_serviceaccount.rendered}"
  depends_on = ["k8s_manifest.cert_manager_namespace"]
}

data "jsone_template" "cert_manager_certificate_crd" {
  template = "${file("${path.module}/cert_manager/certificate_crd.yaml")}"
}

resource "k8s_manifest" "cert_manager_certificate_crd" {
  content    = "${data.jsone_template.cert_manager_certificate_crd.rendered}"
  depends_on = ["k8s_manifest.cert_manager_namespace"]
}

data "jsone_template" "cert_manager_clusterissuer_crd" {
  template = "${file("${path.module}/cert_manager/clusterissuer_crd.yaml")}"
}

resource "k8s_manifest" "cert_manager_clusterissuer_crd" {
  content    = "${data.jsone_template.cert_manager_clusterissuer_crd.rendered}"
  depends_on = ["k8s_manifest.cert_manager_namespace"]
}

data "jsone_template" "cert_manager_issuer_crd" {
  template = "${file("${path.module}/cert_manager/issuer_crd.yaml")}"
}

resource "k8s_manifest" "cert_manager_issuer_crd" {
  content    = "${data.jsone_template.cert_manager_issuer_crd.rendered}"
  depends_on = ["k8s_manifest.cert_manager_namespace"]
}

data "jsone_template" "cert_manager_clusterrole" {
  template = "${file("${path.module}/cert_manager/clusterrole.yaml")}"
}

resource "k8s_manifest" "cert_manager_clusterrole" {
  content    = "${data.jsone_template.cert_manager_clusterrole.rendered}"
  depends_on = ["k8s_manifest.cert_manager_namespace"]
}

data "jsone_template" "cert_manager_clusterrolebinding" {
  template = "${file("${path.module}/cert_manager/clusterrolebinding.yaml")}"
}

resource "k8s_manifest" "cert_manager_clusterrolebinding" {
  content    = "${data.jsone_template.cert_manager_clusterrolebinding.rendered}"
  depends_on = ["k8s_manifest.cert_manager_namespace"]
}

data "jsone_template" "cert_manager_deployment" {
  template = "${file("${path.module}/cert_manager/deployment.yaml")}"
}

resource "k8s_manifest" "cert_manager_deployment" {
  content    = "${data.jsone_template.cert_manager_deployment.rendered}"
  depends_on = ["k8s_manifest.cert_manager_namespace"]
}
