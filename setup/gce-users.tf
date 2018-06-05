locals {
  team_members = [
    "user:dmitchell@mozilla.com",
    "user:jford@mozilla.com",
    "user:pmoore@mozilla.com",
    "user:eperelman@mozilla.com",
    "user:haali@mozilla.com",
    "user:wcosta@mozilla.com",
    "user:coop@mozilla.com",
    "user:jojensen@mozilla.com",
  ]
}

resource "google_project_iam_binding" "team_members" {
  role    = "roles/editor"
  members = "${local.team_members}"
}

# TODO: Maybe don't give this to all members of team?
#       Perhaps can use service account for tf
resource "google_project_iam_binding" "team_members_cluster_admin" {
  role    = "roles/container.admin"
  members = "${local.team_members}"
}
