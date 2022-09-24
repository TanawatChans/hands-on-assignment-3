terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.37.0"
    }
  }
}

provider "google" {
  project = "acme-company"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-c"
}

resource "google_compute_network" "web_network" {
  name = "web"
}
