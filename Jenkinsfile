pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build build'
                archiveArtifacts artifacts: 'dist/yelpCamp.zip'
                archiveArtifacts artifacts: 'dist/yelpCamp_run.zip'
            }
        }
        stage('DeployToStaging') { 
            steps {
                withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    sshPublisher(
                        failOnError: true,
                        continueOnError: false,
                        publishers: [
                            sshPublisherDesc(
                                configName: 'staging',
                                sshCredentials: [
                                    username: "$USERNAME",
                                    encryptedPassphrase: "$USERPASS"
                                ], 
                                transfers: [
                                    sshTransfer(
                                        sourceFiles: 'dist/yelpCamp.zip', 'dist/yelpCamp_run.zip'
                                        removePrefix: 'dist/',
                                        remoteDirectory: '/tmp',
                                        execCommand: 'unzip /tmp/yelpCamp_run.zip -d /tmp &&  sh /tmp/run.sh'
                                        //execCommand: 'sudo /usr/bin/systemctl stop webAppUseCase.service && rm -rf /opt/webAppUseCase/* && unzip /tmp/app.zip -d /opt/webAppUseCase && sudo /usr/bin/systemctl start webAppUseCase'
                                    )
                                ]
                            )
                        ]
                    )
                }
            }
        }
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
                                        sourceFiles:'dist/yelpCamp.zip', 'dist/yelpCamp_run.zip'
                                        removePrefix: 'dist/',
                                        remoteDirectory: '/tmp',
                                        execCommand: 'unzip /tmp/yelpCamp_run.zip -d /tmp &&  sh /tmp/run.sh'
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