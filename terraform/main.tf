provider "aws" {
  profile    = "default"
  region = "eu-west-1"
 
}
resource "aws_instance" "staging_server" {

  ami = "ami-06fe04fb5aba8287e"
  instance_type = "t2.micro"
  key_name      = "manuel_jce"
  subnet_id = "subnet-05e96d0ea715be1fc"
  vpc_security_group_ids = ["sg-0d7419d6d15cba7e0"]
  
  

  connection {
    type     = "ssh"
    user     = "jenkins"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }

  provisioner "local-exec"{
    command = "echo ${aws_instance.staging_server.private_key} > /jenkins_tmp/ip.txt"
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

