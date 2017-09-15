pipeline {
    agent { label 'master'}

    environment {
        version = "${env.BUILD_TAG}"
    }

    stages {
        stage('Setup ECR') {
            steps {
                script {
                    dir('devops/terraform/global/ecr') {
                        sh 'terragrunt plan'
                        sh 'terragrunt apply'

                        def json = sh(returnStdout:true, script: 'terragrunt output -json')?.trim()
                        echo "json: $json"
                        def parsedJson = new groovy.json.JsonSlurperClassic().parseText(json)

                        env.repo = parsedJson?.repository_name?.value
                        env.ecrUrl = parsedJson?.repository_url?.value
                    }
                }
            }
        }

        stage('Gradle Build') {
            steps {
                sh 'bash ./gradlew build'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $repo .'
            }
        }

        stage('Docker Tag') {
            steps {
                sh '''docker tag $repo:latest $ecrUrl:latest
                docker tag $repo:latest $ecrUrl:$version'''
            }
        }

        stage('Docker Push') {
            steps {
                sh 'aws ecr get-login --region us-west-2 | sh'
                sh '''docker push $ecrUrl:latest
                  docker push $ecrUrl:$version'''
            }
        }

        stage('Update ECS Cluster') {
            steps {
                dir('devops/terraform/dev/ecs-cluster') {
                    sh 'terragrunt plan -var docker_image_version=$version'
                    sh 'terragrunt apply -var docker_image_version=$version'
                }
            }
        }

        stage('Update ECS Service') {
            steps {
                dir('devops/terraform/dev/ecs-service') {
                    sh 'terragrunt plan -var docker_image_version=$version'
                    sh 'terragrunt apply -var docker_image_version=$version'
                }
            }
        }
    }

    post {
        always {
            step([$class: 'Mailer', notifyEveryUnstableBuild: true, recipients: 'dalling.eric@gmail.com', sendToIndividuals: false])
        }
    }
}