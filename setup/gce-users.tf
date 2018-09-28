locals {
  team_members = [
    "user:dmitchell@mozilla.com",
    "user:jford@mozilla.com",
    "user:pmoore@mozilla.com",
    "user:haali@mozilla.com",
    "user:wcosta@mozilla.com",
    "user:coop@mozilla.com",
    "user:bstack@mozilla.com",
    "user:istorozhko@mozilla.com",
  ]
}

resource "google_project_iam_member" "team_members" {
  role   = "roles/editor"
  count  = "${length(local.team_members)}"
  member = "${local.team_members[count.index]}"
}

resource "google_project_iam_member" "team_members_cluster_admin" {
  role   = "roles/container.admin"
  count  = "${length(local.team_members)}"
  member = "${local.team_members[count.index]}"
}

data "jsone_template" "admin_bindings" {
  template = "${file("${path.module}/admin_bindings.yaml")}"

  yaml_context = "${jsonencode(map(
    "team_members", "${local.team_members}"
  ))}"
}

resource "k8s_manifest" "admin_bindings" {
  depends_on = ["google_container_cluster.primary"]
  content    = "${data.jsone_template.admin_bindings.rendered}"
}
