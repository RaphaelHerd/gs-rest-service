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
     container('maven') {
       
                stage ('Clone Repository') {
                  checkout scm
                }

                stage('Prepare Environment') {
                    // Install Docker CLI
                    sh """
                    curl -Lo /tmp/docker.tgz https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz
                    mkdir /tmp/docker
                    tar -xf /tmp/docker.tgz -C /tmp/docker
                    find /tmp/docker -type f -executable -exec mv {} /usr/local/bin/ \\;
                    """
                     sh 'docker version'
                }


                stage('maven') {
                        sh 'mvn -f complete/pom.xml package'
                }
               
      }
     
   }
}
