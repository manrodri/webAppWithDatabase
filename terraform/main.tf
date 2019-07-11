provider "aws" {
  profile    = "default"
  region = "eu-west-1"
 
}
resource "aws_instance" "staging_server" {

  ami = "ami-085362a9094e7b5be"
  instance_type = "t2.micro"
  key_name      = "ireland"
  vpc_security_group_ids = ["sg-070c0bddc27ea3ebf"]
  subnet_id = "subnet-6eafc008"

  connection {
    type     = "ssh"
    user     = "jenkins"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }

  provisioner "local-exec"{
    command = "echo ${aws_instance.staging_server.public_ip} > /var/lib/jenkins/ip.txt"
  }

 # provisioner "file" {
 #   source      = "../run.py"
 #   destination = "/tmp/run.py"
  #}

  provisioner "remote-exec" {
    inline = [
      "echo 54.246.157.29 artifactory docker.artifactory docker-local.artifactory docker-remote.artifactory >> /etc/hosts",
     # "python2 /tmp/run.py 3000 ${var.artifact_version}",
      
    ]
  }
  tags = {
    Name = "server deployed by Terraform"
    owner= "manuel"
    provisioned="terraform"
  }
}


