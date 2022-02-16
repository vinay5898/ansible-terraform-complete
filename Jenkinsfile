pipeline {
    agent any

    stages {
        stage ("checkout from GIT") {
            steps {
                git credentialsId: 'github', url: 'https://github.com/vinay5898/terraform-iam-demo.git'
            }
        }
        stage ("terraform init") {
            steps {
                sh 'terraform init'
            }
        }
        stage ("terrafrom plan") {
            steps {
                sh 'terraform plan '
            }
        }
        stage ("terraform apply") {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
    }
}
