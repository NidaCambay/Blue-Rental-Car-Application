pipeline {
    agent any
    parameters {
        choice(name: 'WORKSPACE', choices: ['dev', 'staging', 'prod', 'test'], description: 'Select Terraform Workspace')
    }
    environment {
        AWS_REGION = 'us-east-1'  // AWS bölgesini ayarlayın
    }
}
    stages {
        stage('Set Workspace') {
            steps {
                script {
                    // Set the selected workspace
                    sh "terraform workspace select ${params.WORKSPACE} || terraform workspace new ${params.WORKSPACE}"
                }
            }
        }

        stage('Generate Key Pair') {
            steps {
                script {
                    def keyName = "${params.WORKSPACE}-key"
                    
                    // Eğer key pair yoksa oluştur
                    sh """
                    aws ec2 describe-key-pairs --key-names ${keyName} --region ${env.AWS_REGION} || \
                    aws ec2 create-key-pair --key-name ${keyName} --query 'KeyMaterial' --output text > ${keyName}.pem
                    chmod 400 ${keyName}.pem
                    """
                
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform init'
                    sh "terraform apply --auto-approve"
                }
            }
        }
    post {
        always {
            script {
                // Varsayılan workspace'e geri dön
                sh 'terraform workspace select default'
            }
        }
    }
}
