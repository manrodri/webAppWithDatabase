provider "aws" {
  profile    = "default"
  region = "eu-west-1"
 
}
resource "aws_instance" "staging_server" {

  ami = "ami-025ec0b13f60902a6"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0b0afa51d47dcad45"]
  subnet_id = "subnet-0f97221768fbbfa7c"
  private_ip = "$(var.PRIVATE_IP)"

  tags = {
    Name = "server deployed by Terraform"
    owner= "manuel"
    provisioned="terraform"
  }
}
