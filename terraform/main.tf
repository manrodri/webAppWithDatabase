provider "aws" {
  profile    = "default"
  region = "eu-west-1"
 
}
resource "aws_instance" "staging_server" {

  ami = "ami-025ec0b13f60902a6"
  instance_type = "t2.micro"
  key_name      = "manuel_tech_case"
  private_ip = "192.168.1.240"
  vpc_security_group_ids = ["sg-0b0afa51d47dcad45"]
  subnet_id = "subnet-0f97221768fbbfa7c"
  
  
  // stage('Start app'){
        //     steps{
        //         sh 'cat /etc/hosts'
        //         // echo 'Starting the app...'
        //         // sh "cd terraform"
        //         // sh "PUBLIC_IP=`terraform show | grep 'public_ip = '`"
        //         // sh "ssh -tt jenkins@${PUBLIC_IP}"
        //         // sh 'node /tmp/yelpCampApp/bin/www'
        //     }
        // }
  
  // stage('Start app'){
        //     steps{
        //         sh 'cat /etc/hosts'
        //         // echo 'Starting the app...'
        //         // sh "cd terraform"
        //         // sh "PUBLIC_IP=`terraform show | grep 'public_ip = '`"
        //         // sh "ssh -tt jenkins@${PUBLIC_IP}"
        //         // sh 'node /tmp/yelpCampApp/bin/www'
        //     }
        // }
  // stage('Start app'){
        //     steps{
        //         sh 'cat /etc/hosts'
        //         // echo 'Starting the app...'
        //         // sh "cd terraform"
        //         // sh "PUBLIC_IP=`terraform show | grep 'public_ip = '`"
        //         // sh "ssh -tt jenkins@${PUBLIC_IP}"
        //         // sh 'node /tmp/yelpCampApp/bin/www'
        //     }
        // }

  tags = {
    Name = "server deployed by Terraform"
    owner= "manuel"
    provisioned="terraform"
  }
}


