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
        
        stage('docker') {
            container('maven') {
                sh 'docker version'
            }
        }
     
    }
}
