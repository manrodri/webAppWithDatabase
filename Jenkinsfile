pipeline {
    agent any
    stages {
        // stage('Build') {
        //     steps {
        //         echo env.BUILD_NUMBER
        //         echo 'Running build automation'
    
        //         sh './gradlew build build'
        //         archiveArtifacts artifacts: "dist/yelpCamp.zip"
                
        //     }
        // }
        // stage('publish to artifactory'){
        //     steps{ 
        //        sh "curl -uadmin:AP4yc6KiPJbd7q36GqhzhxVHzFB -T dist/yelpCamp.zip http://artifactory:8081/artifactory/generic-local/yelpCamp.zip"
        //     }
        // }

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
        //             docker.withRegistry('https://registry.hub.docker.com', 'DockerHub') {
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
        //         sh 'cd terraform && terraform plan -out=tfplan -input=false'
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
        //                 echo 'Running ansible playbook to configure staging server'
        //                 sh 'cd ansible && ansible-playbook -b mongodb.yml'

        //         }
        //     }
        // }
        
        stage('DeployToProduction') {
            steps {
                input 'Does the staging environment look OK?'
                milestone(1)
                script{
                    ip= sh 'cat /tmp/public_ip.txt'
                    sh "ssh ${ip}"
                    sh 'echo hello > /tmp/greeting.txt'
                    sh 'hostname'
                }
                
                // script{
                //         try{
                //             sh 'rm -rf .ssh/known_hosts'
                //         } catch(err) {
                //             echo: 'caught error: $err'
                //         }
                //         sh 'ssh 192.168.1.241'
                //         sh "docker pull manrodri/yelpcamp:${env.BUILD_NUMBER}"
                //         try {
                //             sh "docker stop yelpCamp"
                //             sh "docker rm yelpCamp"
                //         } catch (err) {
                //             echo: 'caught error: $err'
                //         }
                //         sh "docker run --restart always --name yelpCamp -p 3000:3000  -d manrodri/yelpcamp:${env.BUILD_NUMBER}"
                // }
            }
        }
    }
}