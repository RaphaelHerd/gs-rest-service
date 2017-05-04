podTemplate(label: 'build-pod', serviceAccount: 'jenkins-agents-serviceaccount', containers: [
//    containerTemplate(name: 'openjdk8', image: 'openjdk:8-alpine', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'maven', image: 'maven', ttyEnabled: true, command: 'cat')
  ]) {
    
    
    env.DOCKER_IMAGE_NAME = 'rest-mvn-sample'
    env.NEXUS_URL = 'hub.itgo-devops.org:18444'
    env.NEXUS_DOCKER_IMAGE_NAME = "${env.NEXUS_URL}/hit/rest-mvn-sample"
    // This sample demonstrates the usage of different containers in one pod
    // and displays the versions of the runtimes and SDKs.
    node('build-pod') {
    
          stage ('Clone Repository') {
          checkout scm
        }
        
        stage('maven') {
            container('maven') {
                sh 'mvn -f complete/pom.xml package'
            }
        }
        
        stage ('Tag and Push Docker Image to Nexus') {
          // Rename Tag for Nexus
          sh "docker tag ${env.DOCKER_IMAGE_NAME}:latest ${env.NEXUS_DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
          sh "docker rmi ${env.DOCKER_IMAGE_NAME}:latest"
          sh "docker tag ${env.NEXUS_DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER} ${env.NEXUS_DOCKER_IMAGE_NAME}:latest"
          // Push
          docker.withRegistry("https://${env.NEXUS_URL}", 'Nexus-Admin') {
            sh "docker push ${env.NEXUS_DOCKER_IMAGE_NAME}:latest"
            sh "docker push ${env.NEXUS_DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
          }
    }
}
