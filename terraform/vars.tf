variable "AWS_REGION" {
  default = "eu-west-1"
}
variable "PRIVATE_IP" {
  default = "192.168.1.131"
}
variable "SUBNET_ID" {
  default = "subnet-0f97221768fbbfa7c"
}
variable "AMIS" {
  type = "map"
  default = {
    eu-west-1 = "ami-025ec0b13f60902a6"
  }
}
