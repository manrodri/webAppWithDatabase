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
}