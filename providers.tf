terraform {
  cloud {
    organization = "Org-Development"

    workspaces {
      name = "terraform-github-actions"
    }
  }
}