podTemplate(label: 'build-pod', serviceAccount: 'jenkins-agents-serviceaccount', 
    containers: [
    containerTemplate(name: 'jnlp', image: 'jenkinsci/jnlp-slave:2.62', args: '${computer.jnlpmac} ${computer.name}'),
    containerTemplate(name: 'docker', image: 'docker:17.04.0-ce', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.5.7', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'maven', image: 'maven', ttyEnabled: true, command: 'cat')
   ],
    volumes: [
      hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock')    
    ]) {
    
     node('build-pod') {

          stage ('get sources') {
            checkout scm

            env.NEXUS_URL = 'hub.itgo-devops.org:18443'
            env.NEXUS_REPOSITORY = "${env.NEXUS_URL}/imaki"
            // write current date without newline at the end into file
            sh "echo -n `date -u` > utc-datetime"
            env.CONT_IMG_UTC_DATETIME = readFile 'utc-datetime'
          }

         container('maven') {
            stage('maven') {
               sh 'mvn -f complete/pom.xml package'
            }
          }
         container('docker') {
            try{
              stage ('docker Build') {
                dockerbuild("rest-mvn-sample")
              }

              stage ('docker push') {
                docker.withRegistry("https://${env.NEXUS_URL}", 'Nexus-Admin') {
                  dockerpush("rest-mvn-sample")
                }
              } // stage 'docker push' end
            } //try end
            finally {
              stage('cleaning up docker images') {
               // dockercleanup("rest-mvn-sample")
              }
            } // finally end
          }
      stage('preparing deployment') {
        echo "Replacing all latest tags with current buildnumber ${env.BUILD_NUMBER}"
        sh """
          sed -i 's/:latest/:${env.BUILD_NUMBER}/g' k8s/*.yaml
        """
      }

      container('kubectl') {
        stage('deployment'){
          sh """
           kubectl version
            // first deploy ns
            kubectl apply -f k8s/namespace.yaml --namespace=sample-rest-ws --record=true
            sleep 10
            // deploy rest of service
            kubectl apply -f k8s --namespace=sample-rest-ws --record=true
            sleep 10
            kubectl describe service sample-rest-ws-external --namespace=sample-rest-ws | grep 'LoadBalancer Ingress'
          """
       }
      }
    } // end build-pod
}

def dockerbuild(name) {
  sh """
    docker build --build-arg CONT_IMG_UTC_DATETIME="${env.CONT_IMG_UTC_DATETIME}" --build-arg CONT_IMG_VER=${name}:${env.BUILD_NUMBER} -t ${env.NEXUS_REPOSITORY}/${name}:${env.BUILD_NUMBER} -t ${env.NEXUS_REPOSITORY}/${name}:latest .
    echo ''
    echo Image size:
    docker images ${env.NEXUS_REPOSITORY}/${name}:${env.BUILD_NUMBER}
    """
}
def dockerpush(name) {
  sh "docker push ${env.NEXUS_REPOSITORY}/${name}:${env.BUILD_NUMBER}"
  sh "docker push ${env.NEXUS_REPOSITORY}/${name}:latest"
}
def dockercleanup(name) {
  sh "docker rmi ${env.NEXUS_REPOSITORY}/${name}:${env.BUILD_NUMBER}"
  sh "docker rmi ${env.NEXUS_REPOSITORY}/${name}:latest"
}
