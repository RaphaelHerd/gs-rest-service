podTemplate(label: 'build-pod', serviceAccount: 'jenkins-agents-serviceaccount', containers: [
//    containerTemplate(name: 'openjdk8', image: 'openjdk:8-alpine', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'maven', image: 'maven', ttyEnabled: true, command: 'cat')
  ]) {

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
    
  //      stage('openjdk8') {
//            container('openjdk8') {
//                sh 'java -version'
//            }
//        }
    }
}
