node('Slave') {
    checkout scm
    def branch = env.BRANCH_NAME ?: 'master'
    def curStage = 'Start'
    def emailList = 'thomas.ramirez@osi.ca.gov'
    def pipelineStatus = 'SUCCESS'

    try {
        emailList = EMAIL_NOTIFICATION_LIST
    } catch (e) {
        // Okay not to perform assignment if EMAIL_NOTIFICATION_LIST is not defined
    }

    try {
        stage('Test') {
            curStage = 'Test'
            sh 'make test'
        }
        stage('Publish') {
            curStage = 'Publish'
            withEnv(["DOCKER_USER=${DOCKER_USER}",
                     "DOCKER_PASSWORD=${DOCKER_PASSWORD}",
                     "FROM_JENKINS=yes"]) {
                sh './bin/publish_image.sh'
            }
        }

        stage('Deploy') {
            curStage = 'Deploy'
            sh "printf \$(git rev-parse --short HEAD) > tag.tmp"
            def imageTag = readFile 'tag.tmp'
            build job: DEPLOY_JOB, parameters: [[
                $class: 'StringParameterValue',
                name: 'IMAGE_TAG',
                value: 'cwds/intake_api_prototype:' + imageTag
            ]]
        }
    }
    catch (e) {
        pipelineStatus = 'FAILED'
        currentBuild.result = 'FAILURE'
    }
    finally {
        try {
            emailext (
                to: emailList,
                subject: "${pipelineStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' in stage ${curStage}",
                body: """<p>${pipelineStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' in stage '${curStage}' for branch '${branch}':</p>
                <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>"""
            )

            slackAlertColor = '#11AB1B'
            slackMessage = "${pipelineStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' completed for branch '${branch}' (${env.BUILD_URL})"

            if(pipelineStatus == 'FAILED') {
              slackAlertColor = '#FF0000'
              slackMessage = "${pipelineStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' in stage '${curStage}' for branch '${branch}' (${env.BUILD_URL})"
            }

            slackSend (color: slackAlertColor, message: slackMessage)
        }
        catch(e) { /* Nothing to do */ }

        stage('Clean') {
            retry(1) {
                sh 'make clean'
            }
        }
    }
}
