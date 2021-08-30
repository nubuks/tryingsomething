pipeline {
    agent any
    environment{
    DOCKER_TAG = getDockerTag()
    registryCredential = "dockerhub"
    registry = "yakmandocker/spring-boot"
}

stages {
    stage('Build docker image') {
        steps{
            sh "docker build . -t yakmandocker/spring-boot:${DOCKER_TAG}"
        }
    }
    stage('Dockerhub push'){
        steps{
            script{
                docker.withRegistry('',registryCredential){
                sh "docker push yakmandocker/spring-boot:${DOCKER_TAG}"
            }
        }
    }
}
    stage('Deploy to K8S'){
        steps{
            sh "chmod +x changeTag.sh"
            sh "./changeTag.sh ${DOCKER_TAG}"
            sshagent(['kops-machine']) {
            sh "scp -o StrictHostKeyChecking=no services.yml node-app-pod.yml ubuntu@54.211.23.16:/home/ec2-user"
            script {
                try {
                    sh "ssh ec2-user@54.211.23.16 kubectl apply -f . -n production"
                }catch(error) {
                    sh "ssh ec2-user@54.211.23.16 kubectl create -f . -n production"
                }
             }
            }
        }
    }
  }

}
def getDockerTag() {
    def tag = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag 
}
