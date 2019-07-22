pipeline {
    agent any
    stages {
        // stage('Build') {
        //     steps {
        //         echo 'Running build automation'
        //         sh './gradlew build'
        //         archiveArtifacts artifacts: "dist/yelpCamp.zip"
                
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
        //                  app.push("${env.BUILD_NUMBER}")
        //                  app.push("latest")
        //             }
        //         }
        //     }
        // }

        stage('Provision staging server'){
            steps{
                echo 'Provisioning staging server with Terraform'
                sh 'cd terraform && terraform init'
                sh "cd terraform && terraform plan -out=tfplan -input=false"
                sh 'cd terraform && terraform apply -lock=false -input=false tfplan'
            }
        }
        
        stage('Configure server'){
            steps{
                script{
                       
                       env.YELPCAMP_HOST = readFile '/jenkins_tmp/ip.txt'
                       env.YELPCAMP_PORT = 3000
                       sh 'python2 add_public_ip.py /jenkins_tmp/ip.txt ansible/hosts'
                       sh 'sleep 20'
                       echo 'Running ansible playbook to configure staging server'
                       sh 'cd ansible && ansible-playbook -i hosts docker.yml '
                        
                }
            }
        }
        
            stage('Deploy Server') {
            steps {
                sh "cd ansible && ansible-playbook -i hosts deploy_container_staging.yml --extra-vars \"build_number=${env.BUILD_NUMBER}\""
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
                    sh "cd ansible && ansible-playbook -i hosts deploy_container_prod.yml --extra-vars \"build_number=${env.BUILD_NUMBER}\""
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

        // stage('publish to artifactory'){
        //      steps{   
        //       sh "curl -uadmin:AP5ANpRzefchDX235LQGLdKZtTv -T dist/yelpCamp.zip \"http://artifactory:8081/artifactory/generic-local/yelpCamp_${env.BUILD_NUMBER}.zip\"" 
        //     }
        //  }
    }
}
  

