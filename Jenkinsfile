pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo env.BUILD_NUMBER
                echo 'Running build automation'
    
                sh './gradlew build build'
                archiveArtifacts artifacts: "dist/yelpCamp.zip"
                
            }
        }
        stage('publish to artifactory'){
            steps{ 
               sh "curl -uadmin:AP4yc6KiPJbd7q36GqhzhxVHzFB -T dist/yelpCamp.zip http://artifactory:8081/artifactory/generic-local/yelpCamp.zip"
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
                    docker.withRegistry('https://registry.hub.docker.com', 'DockerHub') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }

        // stage('Build docker image'){
        //     steps{
        //         sh "mkdir /tmp/app_${env.BUILD_NUMBER} && cd /tmp/app_${env.BUILD_NUMBER}"
        //         sh "unzip dist/yelpCamp.zip -d /tmp/app_${env.BUILD_NUMBER}"
        //         sh 'sudo docker build -t manrodri/yelpcamp .'
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
        


        // stage('Run App'){
        //     steps{
        //         sh "sshpass -p ${env.SSH_PASS} -o StrictHostChecking=no deploy@${env.STAGING_SERVER_IP} node /tmp/app/app.js"
        //     }
        // }

        
        // stage('Run smoke test'){
        //     steps{
        //         sh 'echo hello'
        //     }
        // }
        
        // stage('Deploy to staging server'){
        //     steps{
        //         echo 'Deploying to staging server'
        //         sh 'ssh -tt jenkins@192.168.1.131'
        //         sh 'hostname'
        //         sh """cd /tmp && curl -uadmin:AP4yc6KiPJbd7q36GqhzhxVHzFB -O http://34.244.56.79:8081/artifactory/generic-local/yelpCamp_${env.BUILD_NUMBER}.zip && \
        //                                                 unzip yelpCamp.zip -d /tmp/app_${env.BUILD_NUMBER} > /dev/null &&  \
        //                                                 cd /tmp/app_${env.BUILD_NUMBER} &&  nohup node app_${env.BUILD_NUMBER}/app.js > /tmp/yelpCamp.log &  
        //                                                 """
        //     }
        // }

        // stage('Destroy staging server'){
        //     steps{
        //         input 'Shall we destroy the staging server?'
        //         milestone(1)
        //         echo 'Destroying staging server with Terraform'
        //         sh 'cd terraform && terraform plan -destroy -out=tfdestroyplan -input=false'
        //         sh "cd terraform && terraform apply -lock=false -input=false tfdestroyplan"
        //     }
        // }

        // stage('Destroy staging server'){
        //     steps{
        //         input 'Shall we destroy the staging server?'
        //         milestone(1)
        //         echo 'Destroying staging server'
        //         sh 'cd terraform && terraform plan -destroy -out=tfdestroyplan -input=false'
        //         sh "cd terraform && terraform apply -lock=false -input=false tfdestroyplan"
        //     }
        // }


        // stage('DeployToStaging') { 
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
        //             sshPublisher(
        //                 failOnError: true,
        //                 continueOnError: false,
        //                 publishers: [
        //                     sshPublisherDesc(
        //                         configName: 'staging',
        //                         sshCredentials: [
        //                             username: "$USERNAME",
        //                             encryptedPassphrase: "$USERPASS"
        //                         ], 
        //                         transfers: [
        //                             sshTransfer(
        //                                 //sourceFiles: 'dist/yelpCamp*.zip',
        //                                 //removePrefix: 'dist/',
        //                                 //remoteDirectory: '/tmp',
        //                                 execCommand: """
        //                                                   nohup node /tmp/app/app.sh > /tmp/yelpCamp.log &  
        //                                                 """

        //                                 //execCommand: 'if [[ -e /tmp/run.sh ]] ; then rm -f /tmp/run.sh;  fi &&  unzip /tmp/yelpCamp_run.zip -d /tmp &&  sh /tmp/run.sh && ps aux | grep node',
        //                                 //execTimeout: 10000

        //                                 //execCommand: 'sudo /usr/bin/systemctl stop webAppUseCase.service && rm -rf /opt/webAppUseCase/* && unzip /tmp/app.zip -d /opt/webAppUseCase && sudo /usr/bin/systemctl start webAppUseCase'
        //                             )
        //                         ]
        //                     )
        //                 ]
        //             )
        //         }
        //     }
        // }

        stage('DeployToProduction') {
              
            steps {
                input 'Does the staging environment look OK?'
                milestone(1)
                withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                       
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker pull manrodri/yelpcamp:${env.BUILD_NUMBER}\""
                        
                        try {
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker run --restart always --name yelpCamp -p 3000:3000 -d manrodri/yelpcamp:${env.BUILD_NUMBER}\""
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker stop yelpCamp\""
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker rm yelpCamp\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker run --restart always --name yelpCamp -p 3000:3000 -d manrodri/yelpcamp:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }
    }



        // stage('DeployToProduction') {
        //     steps {
        //         input 'Does the staging environment look OK?'
        //         milestone(1)
        //         withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
        //             sshPublisher(
        //                 failOnError: true,
        //                 continueOnError: false,
        //                 publishers: [
        //                     sshPublisherDesc(
        //                         configName: 'production',
        //                         sshCredentials: [
        //                             username: "$USERNAME",
        //                             encryptedPassphrase: "$USERPASS"
        //                         ], 
        //                         transfers: [
        //                             sshTransfer(
        //                                 sourceFiles:'dist/yelpCamp*.zip',
        //                                 removePrefix: 'dist/',
        //                                 remoteDirectory: '/tmp',
        //                                 execCommand: 'if [[ -e /tmp/run.sh ]] ; then rm -f /tmp/run.sh;  fi &&  unzip /tmp/yelpCamp_run.zip -d /tmp &&  sh /tmp/run.sh && ps aux | grep node',
        //                                 execTimeout: 10000
        //                                 //execCommand: 'sudo /usr/bin/systemctl stop webAppUseCase.service && rm -rf /opt/webAppUseCase/* && unzip /tmp/app.zip -d /opt/webAppUseCase && sudo /usr/bin/systemctl start webAppUseCase'
        //                             )
        //                         ]
        //                     )
        //                 ]
        //             )
        //         }
        //     }
        // }
    }
}