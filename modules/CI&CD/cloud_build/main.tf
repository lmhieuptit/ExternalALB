# resource "google_cloudbuild_trigger" "example" {
#   name        = var.trigger_name
#   description = var.trigger_description

#   github {
#     owner        = var.github_owner
#     name         = var.github_repo
#     push {
#       branch     = var.branch_regex
#     }
#   }

#   build {
#     step {
#       name = "gcr.io/cloud-builders/docker"
#       args = ["build", "-t", var.image_name, "."]
#     }
#     images = [var.image_name]
#   }
# }