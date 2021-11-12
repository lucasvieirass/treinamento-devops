terraform {
  backend "remote" {
    organization = "lucassouza-devops"

    workspaces {
      name = "lucassouza-firstterraform"
    }
  }
}
