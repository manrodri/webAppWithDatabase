provider "aws" {
  profile    = "default"
  region = "eu-west-1"
 
}
resource "aws_instance" "staging_server" {

  ami = "ami-025ec0b13f60902a6"
  instance_type = "t2.micro"
  key_name      = "manuel_tech_case"
  vpc_security_group_ids = ["sg-0b0afa51d47dcad45"]
  subnet_id = "subnet-0f97221768fbbfa7c"
  
  
  connection {
    type     = "ssh"
    user     = "jenkins"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
  
  provisioner "local-exec" {
    command = "\"sudo echo ${aws_instance.staging_server.private_ip} staging.example.com\" >> /etc/hosts"
  }
  provisioner "file" {
    source      = "../run.py"
    destination = "/tmp/run.py"
  }
  provisioner "remote-exec" {
    inline = [
      "python2 /tmp/run.py 3000",
      
    ]
  }

  tags = {
    Name = "server deployed by Terraform"
    owner= "manuel"
    provisioned="terraform"
  }
}


