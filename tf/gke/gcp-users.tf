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
  project = "${google_project.project.id}"
  role   = "roles/editor"
  count  = "${length(local.team_members)}"
  member = "${local.team_members[count.index]}"
}

resource "google_project_iam_member" "team_members_cluster_admin" {
  project = "${google_project.project.id}"
  role   = "roles/container.admin"
  count  = "${length(local.team_members)}"
  member = "${local.team_members[count.index]}"
}
