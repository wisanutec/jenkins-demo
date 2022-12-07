//Define the code repository address.
//def git_url = 'https://github.com/lookforstar/jenkins-demo.git' 
def git_url = 'https://github.com/wisanutec/jenkins-demo.git' 
//Define the SWR login command.
def swr_login = 'docker login -u ap-southeast-2@BJQ2PRFEDAXEHJLZ5Q5T -p 500c3366dce2868c005053afb18db0abf3978f5a996e5ff4fd9d27e513cbe1b8 swr.ap-southeast-2.myhuaweicloud.com'
//Define the SWR zone.
def swr_region = 'ap-southeast-2'
//Define the name of the SWR organization to be uploaded.
//def organization = 'container'
def organization = 'wisanu'
//Define the image name.
def build_name = 'jenkins-demo'
//Certificate ID of the cluster to be deployed
//def credential = 'k8s-token'
def credential = 'k8s-cert'
//def credential = 'eyJhbGciOiJSUzI1NiIsImtpZCI6IlJFbFoyVFY4S1Izci1wZ1ZPX0k3UFB6RlVvaDFaSjhoOTBkVGcxaENMN0kifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZXZvcHMtdG9vbHMiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoiamVua2lucy1hZG1pbi10b2tlbi1tNjhjaiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJqZW5raW5zLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiNzI5NThmMDQtYjFiNC00ZDczLTk4ZWUtMTc5Y2Q5NTQ1MTE2Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmRldm9wcy10b29sczpqZW5raW5zLWFkbWluIn0.s4RgBWrXlVHpcQXQvqPGi8kaSU3MuX_sPcskfNC0XsmnFcX3B-9AvNH7z-zoMZ5_5a93DADBo-_-yKnmsxVoJa7ggHRDCSkzKx1GU3DKgpdLeCJuvSWnY7TQymgno-FrIfkpnBpI1wNkY7-zKMa4Lw02vqmGqR6ZBoPUoVtzQETz_EdqFT6nflLorf3ciiRI2NdfG1z4QKjAFEhcuaPUCq9zZh-57PjMxzkToTz-o7p9uCCzcsP15jFmeq21pvOK3vEOTE9R9Y_teZjAjMP3gSGRBOVwIASOiBK1aloi5oUGBvJm1u7Wz3flHHxfu5TB4pncMbsCmzgbb3GCGDAyAA'
//API server address of the cluster. Ensure that the address can be accessed from the Jenkins cluster.
//def apiserver = 'https://192.168.0.100:6443'
def apiserver = 'https://10.10.7.204:5443'
	


pipeline {
    agent any
    stages {
        stage('Clone') { 
            steps{
                echo "1.Clone Stage" 
                git url: git_url
                script { 
                    build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim() 
                } 
            }
        } 
        stage('Test') { 
            steps{
                echo "2.Test Stage" 
            }
        } 
        stage('Build') { 
            steps{
                echo "3.Build Docker Image Stage" 
                sh "docker build -t swr.${swr_region}.myhuaweicloud.com/${organization}/${build_name}:${build_tag} ." 
                //${build_tag} indicates that the build_tag variable is obtained as the image tag. It is the return value of the git rev-parse --short HEAD command, that is, commit ID.
            }
        } 
        stage('Push') { 
            steps{
                echo "4.Push Docker Image Stage" 
                sh swr_login
                sh "docker push swr.${swr_region}.myhuaweicloud.com/${organization}/${build_name}:${build_tag}" 
            }
        } 
        stage('Deploy') {
            steps{
                echo "5. Deploy Stage"
                echo "This is a deploy step to test"
                script {
                    sh "cat k8s.yaml"
                    sh  "sed -i 's/<BUILD_TAG>/${build_tag}/' k8s.yaml"
                    sh "cat k8s.yaml"
                    echo "begin to config kubenetes"
                    println "${credential},${apiserver} "
                    sh "ls -la"
                    sh "pwd"
                
                    try {
                        withKubeConfig([credentialsId: credential, serverUrl: apiserver]) {
                            sh 'kubectl apply -f k8s.yaml'
                            //The YAML file is stored in the code repository. The following is only an example. Replace it as required.
                        }
                        println "hooray, success"
                    } catch (e) {
                        println "oh no! Deployment failed! "
                        println e
                    }
                }
            }
        }
    }
}