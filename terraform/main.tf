provider "aws" {
  profile    = "default"
  region = "eu-west-1"
  alias = "dublin"
}

resource "aws_instance" "staging_server" {

  provider = "aws.dublin"
  ami = "ami-061ed3b24441147d4"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0b0afa51d47dcad45"]
  subnet_id = "subnet-0f97221768fbbfa7c"

  tags {
    Name = "server deployed by Terraform",
    owner= "manuel",
    provisioned="terraform"
  }
    provisioner "file" {
    source      = "run.py"
    destination = "/tmp/run.py"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /tmp",
      "curl -uadmin:APkvALzx9a7Ygn2kQ17Bcn7BU4 -O http://artifactory.example.com:8081/artifactory/generic-local/yelpCamp.zip",
      "unzip yelpCamp.zip -d /tmp/app > /dev/null",
      "nohup node /tmp/app/bin/www"
    ]
  }
}