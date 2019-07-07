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

        stage('DeployToProduction') {
            steps {
                input 'Does the staging environment look OK?'
                milestone(1)
                withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    sshPublisher(
                        failOnError: true,
                        continueOnError: false,
                        publishers: [
                            sshPublisherDesc(
                                configName: 'production',
                                sshCredentials: [
                                    username: "$USERNAME",
                                    encryptedPassphrase: "$USERPASS"
                                ], 
                                transfers: [
                                    sshTransfer(
                                        sourceFiles:'dist/yelpCamp*.zip',
                                        removePrefix: 'dist/',
                                        remoteDirectory: '/tmp',
                                        execCommand: 'if [[ -e /tmp/run.sh ]] ; then rm -f /tmp/run.sh;  fi &&  unzip /tmp/yelpCamp_run.zip -d /tmp &&  sh /tmp/run.sh && ps aux | grep node',
                                        execTimeout: 10000
                                        //execCommand: 'sudo /usr/bin/systemctl stop webAppUseCase.service && rm -rf /opt/webAppUseCase/* && unzip /tmp/app.zip -d /opt/webAppUseCase && sudo /usr/bin/systemctl start webAppUseCase'
                                    )
                                ]
                            )
                        ]
                    )
                }
            }
        }
    }
}