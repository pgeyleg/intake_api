node {
    checkout scm
    def branch = env.BRANCH_NAME ?: 'master'

    stage('Build') {
        sh './bin/publish_image.sh'
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
