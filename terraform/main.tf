resource "aws_security_group" "app_sg" {
  name        = "todo-app-security-group"
  description = "Security group for TODO application"

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

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "app-server"
  }
}

resource "aws_route53_record" "a_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 60
  records = [aws_instance.app_server.public_ip]
}

resource "aws_route53_record" "wildcard_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "*.${var.domain_name}"
  type    = "A"
  ttl     = 60
  records = [aws_instance.app_server.public_ip]
}

data "aws_route53_zone" "primary" {
  name         = "${var.domain_name}."
  private_zone = false
}

locals {
  project_root = "${path.module}/.."
}

resource "local_file" "ansible_inventory" {
  content  = templatefile("${path.module}/inventory.tpl", { public_ip = aws_instance.app_server.public_ip })
  filename = "${path.module}/../ansible/inventory.ini"
}

resource "null_resource" "ansible_deploy" {
  depends_on = [aws_instance.app_server, local_file.ansible_inventory]

  provisioner "local-exec" {
    command     = "sleep 120 && ANSIBLE_CONFIG=/home/ubuntu/hng12-stage4-todo-infra/ansible.cfg ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /home/ubuntu/hng12-stage4-todo-infra/ansible/inventory.ini /home/ubuntu/hng12-stage4-todo-infra/ansible/playbook.yaml -vvv"
    working_dir = "/home/ubuntu/hng12-stage4-todo-infra"
  }
}