node {
    checkout scm

    try {
        stage('Test') {
            sh 'make test'
        }
    
        stage('Publish') {
            withEnv(["DOCKER_USER=${DOCKER_USER}",
                     "DOCKER_PASSWORD=${DOCKER_PASSWORD}",
                     "FROM_JENKINS=yes"]) {
                sh './bin/publish_image.sh'
            }
        }

        stage('Deploy') {
            sh "printf \$(git rev-parse --short HEAD) > tag.tmp"
            def imageTag = readFile 'tag.tmp'
            build job: DEPLOY_JOB, parameters: [[
                $class: 'StringParameterValue',
                name: 'IMAGE_TAG',
                value: 'cwds/intake_api_prototype:' + imageTag
            ]]
        }
    }
    finally {
        stage('Clean') {
            sh 'make clean'
        }
    }
}
