provider "aws" {
  profile    = "default"
  region = "eu-west-1"
  alias = "dublin"
}

resource "aws_instance" "staging server" {

  provider = "aws.dublin"
  ami = "ami-01e6a0b85de033c99"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0b0afa51d47dcad45"]
  subnet_id = "subnet-0f97221768fbbfa7c"

  tags {
    Name = "staging server Terraform",
    owner= "manuel"
  }
}