resource "aws_key_pair" "ssh" {
  key_name   = "default"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "web" {
  name        = "webserver"
  description = "Public HTTP + SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-2757f631"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.ssh.id}"
  vpc_security_group_ids = [ "${aws_security_group.web.id}" ]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
      timeout = "5m"
      agent = true
    }

    inline = [
      "sudo apt-get update -y && apt-get upgrade -y",
      "sudo apt-get install nginx -y"
    ]
  }
}

output "web_public_dns" {
  value = "${aws_instance.web.public_dns}"
}
