provider "aws" {
  profile    = "default"
  region = "eu-west-1"
 
}
resource "aws_instance" "staging_server" {

  ami = "ami-0a901aa2ba3f90afa"
  instance_type = "t2.micro"
  key_name      = "manuel_jce"
  
  

  provisioner "local-exec"{
    command = "echo ${aws_instance.staging_server.private_ip} > /jenkins_tmp/ip.txt"
  }

    connection {
    type     = "ssh"
    user     = "jenkins"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
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

