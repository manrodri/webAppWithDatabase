pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build'
                archiveArtifacts artifacts: "dist/yelpCamp.zip"
                
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    app = docker.build("manrodri/yelpcamp")
                }
            }
        }
        stage('Push Docker Image') {
            
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerKey') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }

        stage('Provision staging server'){
            steps{
                echo 'Provisioning staging server with Terraform'
                sh 'cd terraform && /opt/terraform/terraform init'
                sh "cd terraform && /opt/terraform/terraform plan -out=tfplan -input=false -var \"artifact_version=${env.BUILD_NUMBER}\""
                sh 'cd terraform && /opt/terraform/terraform apply -lock=false -input=false tfplan'
            }
        }
        
        stage('Configure staging server'){
            steps{
                script{
                       env.YELPCAMP_HOST = readFile '/jenkins_tmp/ip.txt'
                       env.YELPCAMP_PORT = 3000
                       sh 'python2 add_public_ip.py /jenkins_tmp/ip.txt ansible/hosts'
                       sh 'cat ansible/hosts'
                        try {
                            sh 'sudo rm -r /home/deploy/.ssh/known_hosts'
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh 'sleep 20'
                        sh 'cat ansible/hosts'
                        echo 'Running ansible playbook to configure staging server'
                        sh 'cd ansible && ansible-playbook -i hosts docker.yml '
                        

                }
            }
        }
        
            stage('Deploy To Staging Server') {
            steps {
                echo "`cat /jenkins_tmp/ip.txt`"
                

                withCredentials([usernamePassword(credentialsId: 'jenkins_webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script{
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /jenkins_tmp/ip.txt` \"docker pull manrodri/yelpcamp:${env.BUILD_NUMBER}\""
                        try {
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /jenkins_tmp/ip.txt` \"docker stop yelpCamp\""
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /jenkins_tmp/ip.txt` \"docker rm yelpCamp\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /jenkins_tmp/ip.txt` \"docker run  --name yelpCamp -p 3000:3000  -d manrodri/yelpcamp:${env.BUILD_NUMBER}\""

                    }
                }
            }
        }
        stage('UAT'){
            steps{
                
                sh 'sleep 10'
                sh "cd smokeTest && python2 -m unittest test_smoke"
            }
        }
        stage('Deploy to production'){ 
                steps{
                    input 'Does the staging environment look OK?'
                    milestone(1)
                    withCredentials([usernamePassword(credentialsId: 'jenkins_webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script{
                        
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /jenkins_tmp/ip.txt` \"docker stop yelpCamp\""
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /jenkins_tmp/ip.txt` \"docker rm yelpCamp\""
                        
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /jenkins_tmp/ip.txt` \"docker run --restart always --name yelpCamp -p 80:3000  -d manrodri/yelpcamp:${env.BUILD_NUMBER}\""
                    }
                }

            }
        }
        stage('smoke test'){
            steps{
                script{
                    env.YELPCAMP_PORT = 80
                    sh 'sleep 10'
                    sh "cd smokeTest && python2 -m unittest test_smoke"
                }
            }
        }

        stage('publish to artifactory'){
             steps{ 
               
              sh "curl -uadmin:AP5ANpRzefchDX235LQGLdKZtTv -T dist/yelpCamp.zip \"http://34.245.175.210:8081/artifactory/generic-local/yelpCamp_${env.BUILD_NUMBER}.zip\""
       
               
            }
         }
    }
}

