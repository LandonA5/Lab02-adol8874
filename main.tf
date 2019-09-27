provider "google" {
  project = "premium-gear-252201"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  connection {
    type = "ssh"
    user = "root"
    host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

 provisioner "file" {
    source      = "install.sh"
    destination = "/tmp/install.sh"
  }

 provisioner "file" {
    source      = "www"
    destination = "/tmp/www"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "/tmp/install.sh",
    ]
  }
}

