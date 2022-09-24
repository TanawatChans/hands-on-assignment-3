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


################# web-public #################
resource "google_compute_firewall" "web_public_firewall" {
 name    = "web-public-firewall"
 network = google_compute_network.web_network.name

 allow {
   protocol = "tcp"
   ports    = ["80","443"]
 }

 source_ranges = ["0.0.0.0/0"]
 target_tags = ["web-public"]
}

resource "google_compute_instance" "web_public_instance" {
  name         = "web-public"
  description = "web-public allow traffic on ports 80 and 443 from anywhere"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-c"

  tags = ["web-public"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.web_network.name
    access_config {
    }
  }
}


################# web-application #################
resource "google_compute_firewall" "web_application_firewall" {
 name    = "web-application-firewall"
 network = google_compute_network.web_network.name

 allow {
   protocol = "tcp"
   ports    = ["8080"]
 }

 source_tags = ["web-public"]
 target_tags = ["web-application"]
}

resource "google_compute_instance" "web_application_instance" {
  name         = "web-application"
  description  = "web-application allow traffic on port 8080 from web-public"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-c"

  tags = ["web-application"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.web_network.name
    access_config {
    }
  }
}
