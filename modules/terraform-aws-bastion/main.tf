terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

resource "aws_instance" "bastion" {
  ami             = data.aws_ami.bastion_ami.id
  instance_type   = var.ec2_instance_type
  security_groups = var.security_group_ids
  subnet_id       = var.application_subnets[0]
  key_name        = var.ec2_key_pair_name

  tags = {
    Name = "Bastion"
  }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
}