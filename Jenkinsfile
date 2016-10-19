node {
    checkout scm

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
            value: 'casecommons/intake_api_prototype:' + imageTag
        ]]
    }
}
