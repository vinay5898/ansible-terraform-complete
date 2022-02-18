locals {
  vpc_id           = "vpc-0aaf9adcb163c78c7"
  subnet_id        = "subnet-04f4f48a3a1ce69b9"
  ssh_user         = "ubuntu"
  key_name         = "aws_key"
  private_key_path = "/var/lib/jenkins/aws_key.pem"
#  ansible_file_path = "/var/lib/jenkins/copy.yaml"
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "nginx" {
  name   = "nginx_access"
  vpc_id = local.vpc_id

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
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  ami                         = "ami-0851b76e8b1bce90b"
  subnet_id                   = local.subnet_id
  instance_type               = "t2.nano"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.nginx.id]
  key_name                    = local.key_name


  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.nginx.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.nginx.public_ip}, --private-key ${local.private_key_path} copy.yaml"
  }

}
output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}


