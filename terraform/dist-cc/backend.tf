terraform {
  cloud {
    organization = "CCHome"

    workspaces {
      name = "dist-cc"
    }
  }
}