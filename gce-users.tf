resource "google_project_iam_binding" "team_members" {
  role    = "roles/editor"
  members = [
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
