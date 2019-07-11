pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo "${HOSTNAME}"
                echo env.BUILD_NUMBER
                echo 'Running build automation'
    
                sh './gradlew build'
                archiveArtifacts artifacts: "dist/yelpCamp.zip"
                
            }
        }
        stage('publish to artifactory'){
            steps{ 
               
               sh "curl -uadmin:AP2wbyNWUQRetr9rDNeQTGkTsqH -T dist/yelpCamp.zip http://artifactory:8081/artifactory/generic-local/yelpCamp_${env.BUILD_NUMBER}.zip"
               
            }
        }



        // stage('Build Docker Image') {
        //     steps {
        //         script {
        //             app = docker.build("manrodri/yelpcamp")
        //         }
        //     }
        // }
        // stage('Push Docker Image') {
            
        //     steps {
        //         script {
        //             docker.withRegistry('https://registry.hub.docker.com', 'dockerKey') {
        //                 app.push("${env.BUILD_NUMBER}")
        //                 app.push("latest")
        //             }
        //         }
        //     }
        // }

        // stage('Provision staging server'){
        //     steps{
        //         echo 'Provisioning staging server with Terraform'
        //         sh 'cd terraform && terraform init'
        //         sh "cd terraform && terraform plan -out=tfplan -input=false -var \"artifact_version=${env.BUILD_NUMBER}\""
        //         sh 'cd terraform && terraform apply -lock=false -input=false tfplan'
                

        //     }
        // }
        
        // stage('Configure staging server'){
        //     steps{
        //         script{
        //                 try {
        //                     sh 'sudo rm -r /home/deploy/.ssh/known_hosts'
        //                 } catch (err) {
        //                     echo: 'caught error: $err'
        //                 }
        //                 sh 'python add_public_ip.py ansible/hosts'
        //                 echo 'Running ansible playbook to configure staging server'
        //                 sh 'cd ansible && ansible-playbook -b config_server.yml '
        //                 script{
        //                     env.INSTANCE_PUBLIC_IP= readFile '/tmp/ip.txt'
        //                     echo "${INSTANCE_PUBLIC_IP}"
        //                 }

        //         }
        //     }
        // }
        
        //     stage('Deploy To Staging Server') {
        //     steps {
                
        //         withCredentials([usernamePassword(credentialsId: 'jenkins_webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
        //             script{
        //                 env.YELPCAMP_HOST = readFile '/tmp/public_ip.txt'
                        
        //                 sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /tmp/public_ip.txt` \"docker pull manrodri/yelpcamp:${env.BUILD_NUMBER}\""
        //                 try {
        //                     sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /tmp/public_ip.txt` \"docker stop yelpCamp\""
        //                     sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /tmp/public_ip.txt` \"docker rm yelpCamp\""
        //                 } catch (err) {
        //                     echo: 'caught error: $err'
        //                 }
        //                 sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /tmp/public_ip.txt` \"docker run  --name yelpCamp -p 3000:3000  -d manrodri/yelpcamp:${env.BUILD_NUMBER}\""

        //             }
        //         }
        //     }
        // }
        // stage('UAT'){
        //     steps{
        //         sh 'sleep 20'
        //         sh "cd smokeTest && python -m unittest test_smoke"
        //     }
        // }
        // stage('Deploy to production'){ 
        //         steps{
        //             input 'Does the staging environment look OK?'
        //             milestone(1)
        //             withCredentials([usernamePassword(credentialsId: 'jenkins_webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
        //             script{
                        
        //                 sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /tmp/public_ip.txt` \"docker stop yelpCamp\""
        //                 sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /tmp/public_ip.txt` \"docker rm yelpCamp\""
                        
        //                 sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@`cat /tmp/public_ip.txt` \"docker run --restart always --name yelpCamp -p 80:3000  -d manrodri/yelpcamp:latest\""
        //             }
        //         }

        //     }
        // }
        // stage('smoke test'){
        //     steps{
        //         script{
        //             env.YELPCAMP_PORT = 80
        //             sh 'sleep 10'
        //             sh "cd smokeTest && python -m unittest test_smoke"
        //         }
        //     }
        // }
    }
}