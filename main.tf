terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "Terraform-EC2-Web"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              echo "<h1>Hello World from Terraform EC2!</h1>" | sudo tee /var/www/html/index.html
              systemctl enable nginx
              systemctl start nginx
              EOF
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}
