provider "aws" {
  profile    = "default"
  region = "eu-west-1"
 
}
resource "aws_instance" "staging_server" {

  ami = "ami-054f62ee2d35a7b07"
  instance_type = "t2.micro"
  key_name      = "ireland"
  private_ip    = "10.10.10.240"
  subnet_id = "subnet-0c8c4704d89a2a892"
  
  

  connection {
    type     = "ssh"
    user     = "jenkins"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }

  provisioner "local-exec"{
    command = "echo ${aws_instance.staging_server.public_ip} > /jenkins_tmp/ip.txt"
  }

 provisioner "file" {
   source      = "../run.py"
   destination = "/tmp/run.py"
  }

  provisioner "remote-exec" {
    inline = [
     "python2 /tmp/run.py 3000 ${var.artifact_version}",
      
    ]
  }
  tags = {
    Name = "server deployed by Terraform"
    owner= "manuel"
    provisioned="terraform"
  }
}


