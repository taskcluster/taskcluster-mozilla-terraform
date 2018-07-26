data "template_file" "tls_secret" {
  template = "${file("${path.module}/tls_secret.yaml")}"

  vars {
    tls_crt = "${var.taskcluster_staging_crt}"
    tls_key = "${var.taskcluster_staging_key}"
  }
}

resource "k8s_manifest" "taskcluster-secrets" {
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
  count   = "${length(data.jsone_templates.nginx_ingress.rendered) - 1}"
  content = "${data.jsone_templates.nginx_ingress.rendered[count.index + 1]}"
  depends_on = ["k8s_manifest.nginx_ingress_namespace"]
}
