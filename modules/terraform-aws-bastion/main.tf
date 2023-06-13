terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

# Get latest AMI ID for Amazon Linux2 OS
data "aws_ami" "amzlinux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.main.id] # var.security_group_ids
  subnet_id              = var.public_subnet_id
  key_name               = var.ec2_public_key_name

  tags = {
    Name = "bastion"
  }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  tags = {
    Name = "bastion"
  }
}

