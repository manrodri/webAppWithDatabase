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
               sh "curl -uadmin:AP4yc6KiPJbd7q36GqhzhxVHzFB -T dist/yelpCamp.zip http://34.244.56.79:8081/artifactory/generic-local/yelpCamp.zip"
            }
        }

        stage('Provision staging server'){
            steps{
                echo 'Provisioning staging server with Terraform'
                sh 'cd terraform && terraform init'
                sh 'cd terraform && terraform plan -out=tfplan -input=false'
                sh 'cd terraform && terraform apply -lock=false -input=false tfplan'
            }
        }
        
        stage('Run smoke test'){
            steps{
                sh 'echo hello'
            }
        }
        
        stage('Deploy to staging server'){
            steps{
                sh 'User: $(whoami)'
                echo 'Deploying to staging server'
                sh 'ssh jenkins@192.168.1.131'
                sh 'echo hello > /tmp/test.txt'
            }
        }

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
        //                                 execCommand: """cd /tmp && curl -uadmin:AP4yc6KiPJbd7q36GqhzhxVHzFB -O http://34.244.56.79:8081/artifactory/generic-local/yelpCamp.zip && \
        //                                                 unzip yelpCamp.zip -d /tmp/app > /dev/null &&  \
        //                                                 cd /tmp/app &&  nohup node /tmp/app.sh > /tmp/yelpCamp.log &  
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