provider "aws" {
  profile    = "default"
  region = "eu-west-1"
 
}
resource "aws_instance" "staging_server" {

  ami = "ami-06fe04fb5aba8287e"
  instance_type = "t2.micro"
  key_name      = "manuel_jce"
  subnet_id = "subnet-05e96d0ea715be1fc"
  

  connection {
    type     = "ssh"
    user     = "jenkins"
   password = "${var.jenkins_password}"
  }

  provisioner "local-exec"{
    command = "echo ${aws_instance.staging_server.private_ip} > /jenkins_tmp/ip.txt"
  }

  provisioner "file" {
    source      = "/jenkins_tmp/ip.txt"
    destination = "/tmp/ip.txt"
  }

  tags = {
    Name = "server deployed by Terraform"
    owner= "manuel"
    provisioned="terraform"
  }
}

