# Create a Null Resource and Provisioners
resource "null_resource" "copy_ec2_keys" {
  depends_on = [aws_eip.bastion]
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type        = "ssh"
    host        = aws_eip.bastion.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("~/.ssh/terragrunt-eks.pem")
  }

  ## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = "~/.ssh/terragrunt-eks.pem"
    destination = "/tmp/terragrunt-eks.pem"
  }
  ## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/terragrunt-eks.pem"
    ]
  }
  # ## Local Exec Provisioner:  local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  #   provisioner "local-exec" {
  #     command = "echo VPC created on `date` and VPC ID: ${var.vpc_id} >> creation-time-vpc-id.txt"
  #     working_dir = "local-exec-output-files/"
  #     #on_failure = continue
  #   }

}