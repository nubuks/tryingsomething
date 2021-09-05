pipeline {
    agent any
    environment{
    DOCKER_TAG = getDockerTag()
    registryCredential = "docker-hub"
    registry = "yakmandocker/srping-boot"
}

stages {
    stage('Build docker image') {
        steps{
            sh "docker build . -t yakmandocker/srping-boot:${DOCKER_TAG}"
        }
    }
    stage('Dockerhub push'){
        steps{
            script{
                docker.withRegistry('',registryCredential){
                sh "docker push yakmandocker/srping-boot:${DOCKER_TAG}"
            }
        }
    }
}
    stage('Deploy to K8S'){
        steps{
            sh "chmod +x changeTag.sh"
            sh "./changeTag.sh ${DOCKER_TAG}"
            sshagent(['kops-machine']) {
            sh "scp -o StrictHostKeyChecking=no services.yml node-app-pod.yml ec2-user@52.55.69.223:/home/ec2-user"
            script {
                try {
                    sh "ssh ec2-user@52.55.69.223 kubectl apply -f . -n production"
                }catch(error) {
                    sh "ssh ec2-user@52.55.69.223 kubectl create -f . -n production"
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
