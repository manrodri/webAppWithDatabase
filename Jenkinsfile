pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build'
                archiveArtifacts artifacts: 'dist/yelpCamp.zip'
                archiveArtifacts artifacts: 'dist/yelpCamp_run.zip'
                echo 'Build, unit test and packaging done.....'      
            }
        }
        stage('Archive artifact'){
            steps{
                 echo 'Archiving artifact to jfrog aritifactory......'
                 sh 'curl -uadmin:APkvALzx9a7Ygn2kQ17Bcn7BU4 -T dist/yelpCamp.zip "http://54.72.240.241:8081/artifactory/generic-local/yelpCamp.zip"'
                 sh 'curl -uadmin:APkvALzx9a7Ygn2kQ17Bcn7BU4 -T dist/yelpCamp_run.zip "http://54.72.240.241:8081/artifactory/generic-local/yelpCamp_run.zip"'
                 echo 'Artifact saved.......'
            }
        }

        stage('DeployToStaging') { 
            steps {
                echo 'Login in to Staging server....'
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
                                        execCommand: '''cd /tmp && \
                                        curl -uadmin:APkvALzx9a7Ygn2kQ17Bcn7BU4 -O "http://54.72.240.241:8081/artifactory/generic-local/yelpCamp.zip" && \
                                        curl -uadmin:APkvALzx9a7Ygn2kQ17Bcn7BU4 -O "http://54.72.240.241:8081/artifactory/generic-local/yelpCamp_run.zip" && \
                                        unzip yelpCamp_run.zip -d /tmp/run.sh && sh run.sh
                                        ''' 
                                    )
                                ]
                            )
                        ]
                    )
                }
            }
        }
        stage('smoke tests'){
            steps{
                echo 'running smoke tests....'
                sh 'cd smokeTest'
                sh 'python -m unittest smoke_test.py'
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