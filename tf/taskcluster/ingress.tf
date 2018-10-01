data "template_file" "tls_secret" {
  template = "${file("${path.module}/tls_secret.yaml")}"

  vars {
    tls_crt = "${var.root_url_tls_crt}"
    tls_key = "${var.root_url_tls_key}"
  }
}

resource "k8s_manifest" "tls_secrets" {
  content = "${data.template_file.tls_secret.rendered}"
}

data "jsone_templates" "nginx_ingress" {
  template = "${file("${path.module}/nginx_ingress.yaml")}"
}

// This must come before nginx_ingress below
resource "k8s_manifest" "nginx_ingress_namespace" {
  content = "${data.jsone_templates.nginx_ingress.rendered[0]}"
}

resource "k8s_manifest" "nginx_ingress" {
  count      = "${length(data.jsone_templates.nginx_ingress.rendered) - 1}"
  content    = "${data.jsone_templates.nginx_ingress.rendered[count.index + 1]}"
  depends_on = ["k8s_manifest.nginx_ingress_namespace"]
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
  depends_on = ["k8s_manifest.nginx_ingress"]
  content    = "${data.jsone_template.acme_ingress.rendered}"
}
