provider "aws" {
  profile    = "default"
  region = "eu-west-1"
 
}
resource "aws_instance" "staging_server" {

  ami = "ami-00dcc1f173616a7b3"
  instance_type = "t2.micro"
  key_name      = "ireland"
  subnet_id = "subnet-0c8c4704d89a2a892"
  vpc_security_group_ids = ["sg-036e368df116c1235"]
  
  

  connection {
    type     = "ssh"
    user     = "jenkins"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }

  provisioner "local-exec"{
    command = "echo ${aws_instance.staging_server.public_ip} > /jenkins_tmp/ip.txt"
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


