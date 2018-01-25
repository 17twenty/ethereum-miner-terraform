provider "aws" {
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
  region     = "${var.region}"
  version    = "~> 1.2.0"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "fleet-admin"
  public_key = "${file("./keys/aws_terraform.pub")}"
}

resource "aws_default_vpc" "default" {
  tags {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "fleet_sg" {
  name   = "fleet-sg"
  vpc_id = "${aws_default_vpc.default.id}"

  # SSH access needed for provisioner
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "fleet-heavy" {
  tags {
    Name = "fleet-heavy-${count.index}"
  }

  count = "${var.count}"

  #   ami             = "ami-cd0f5cb6"
  ami             = "ami-37bb714d"
  instance_type   = "g2.8xlarge"
  security_groups = ["${aws_security_group.fleet_sg.name}"]

  // Apply our generated key
  key_name = "${aws_key_pair.ssh_key.key_name}"

  provisioner "file" {
    source      = "./files/eth.service"
    destination = "/tmp/eth.service"
  }

  provisioner "file" {
    source      = "./files/ethminer"
    destination = "/tmp/ethminer"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("./keys/aws_terraform")}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/ethminer",
      "sudo mv /tmp/eth.service /etc/systemd/system/eth.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart eth.service",
    ]
  }
}

resource "aws_instance" "fleet-light" {
  tags {
    Name = "fleet-light-${count.index}"
  }

  count = "${var.count}"

  #   ami             = "ami-cd0f5cb6"
  ami             = "ami-37bb714d"
  instance_type   = "g2.2xlarge"
  security_groups = ["${aws_security_group.fleet_sg.name}"]

  // Apply our generated key
  key_name = "${aws_key_pair.ssh_key.key_name}"

  provisioner "file" {
    source      = "./files/eth.service"
    destination = "/tmp/eth.service"
  }

  provisioner "file" {
    source      = "./files/ethminer"
    destination = "/tmp/ethminer"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("./keys/aws_terraform")}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/ethminer",
      "sudo mv /tmp/eth.service /etc/systemd/system/eth.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart eth.service",
    ]
  }
}
