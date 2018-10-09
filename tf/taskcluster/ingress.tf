data "jsone_template" "ingress_namespace" {
  template = "${file("${path.module}/ingress_namespace.yaml")}"
}

resource "k8s_manifest" "ingress_namespace" {
  content = "${data.jsone_template.ingress_namespace.rendered}"
}

data "template_file" "tls_secret" {
  template = "${file("${path.module}/tls_secret.yaml")}"

  vars {
    tls_crt = "${var.root_url_tls_crt}"
    tls_key = "${var.root_url_tls_key}"
  }
}

resource "k8s_manifest" "tls_secrets" {
  content = "${data.template_file.tls_secret.rendered}"
  depends_on = ["k8s_manifest.ingress_namespace"]
}

data "jsone_templates" "ingress_controller" {
  template = "${file("${path.module}/ingress_controller.yaml")}"
}

resource "k8s_manifest" "ingress_controller" {
  count      = "${length(data.jsone_templates.ingress_controller.rendered)}"
  content    = "${data.jsone_templates.ingress_controller.rendered[count.index]}"
  depends_on = ["k8s_manifest.ingress_namespace"]
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
  content    = "${data.jsone_template.acme_ingress.rendered}"
}
