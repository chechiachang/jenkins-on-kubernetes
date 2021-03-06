def app_dir = '/home/jenkins/go/src/github.com/chechiachang/jenkins-x-on-kubernetes'

pipeline {
  agent {
    label "jenkins-go"
  }
  environment {
    ORG = 'chechiachang'
    APP_NAME = 'jenkins-x-on-kubernetes'
    CHARTMUSEUM_CREDS = credentials('jenkins-x-chartmuseum')
  }
  stages {
    stage('Test') {
      steps {
        container('go') {
          checkout scm
          sh "make test"
        }
      }
    }

    stage('Build') {
      steps {
        container('go') {
          sh "make build"
        }
      }
    }

    stage('Run & Verify') {
      steps {
        container('mysql') {
          echo "Running MySQL"
        }
        container('reids') {
          echo "Running Redis"
        }
        container('go') {
          sh "nohup ./bin/jenkins-x-on-kubernetes &"
        }
      }
    }

    stage('Parallel') {
      parallel {
        stage('Verify home') {
          steps {
            container('go') {
              echo "HTTP request to verify home"
              sh "curl http://localhost:8080/"
              sleep 10
              echo "Wake up"
            }
          }
        }
        stage('Verify health check') {
          steps {
            container('go') {
              echo "HTTP request to verify application health check"
              sh "curl http://localhost:8080/health"
              sleep 15
              echo "Wake up"
            }
          }
        }
        stage('Verify regression tests') {
          steps {
            container('go') {
              echo "Running regression test suite"
              sh "curl http://localhost:8080/"
              sleep 5
              echo "Wake up"
            }
          }
        }
      }
    }

    stage('CI Build and push snapshot') {
      when {
        branch 'PR-*'
      }
      environment {
        PREVIEW_VERSION = "0.0.0-SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER"
        PREVIEW_NAMESPACE = "$APP_NAME-$BRANCH_NAME".toLowerCase()
        HELM_RELEASE = "$PREVIEW_NAMESPACE".toLowerCase()
      }
      steps {
        container('go') {
          dir(app_dir) {
            checkout scm
            sh "make linux"
            sh "export VERSION=$PREVIEW_VERSION && skaffold build -f skaffold.yaml"
            sh "jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:$PREVIEW_VERSION"
          }
          dir(app_dir + '/charts/preview') {
            sh "make preview"
            sh "jx preview --app $APP_NAME --dir ../.."
          }
        }
      }
    }

    stage('Build Release') {
      when {
        branch 'master'
      }
      steps {
        container('go') {
          dir(app_dir) {
            checkout scm

            // ensure we're not on a detached head
            sh "git checkout master"
            sh "git config --global credential.helper store"
            sh "jx step git credentials"

            // so we can retrieve the version in later steps
            sh "echo \$(jx-release-version) > VERSION"
            sh "jx step tag --version \$(cat VERSION)"
            sh "make build"
            sh "export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml"
            sh "jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:\$(cat VERSION)"
          }
        }
      }
    }

    stage('Promote to Environments') {
      when {
        branch 'master'
      }
      steps {
        container('go') {
          dir(app_dir + '/charts/jenkins-on-kubernetes') {
            sh "jx step changelog --version v\$(cat ../../VERSION)"

            // release the helm chart
            sh "jx step helm release"

            // promote through all 'Auto' promotion Environments
            sh "jx promote -b --all-auto --timeout 1h --version \$(cat ../../VERSION)"
          }
        }
      }
    }
  }
}
