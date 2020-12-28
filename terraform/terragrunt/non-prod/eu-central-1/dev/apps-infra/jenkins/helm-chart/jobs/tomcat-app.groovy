multibranchPipelineJob('backend/tomcat-app') {
  factory {
    workflowBranchProjectFactory {
      scriptPath('Jenkinsfile')
    }
  }
  branchSources {
    branchSource {
      source {
        github {
          id('tomcat-app')
          repoOwner('ahmad-hamade')
          repository('tomcat-app')
          repositoryUrl('https://github.com/ahmad-hamade/tomcat-app.git')
          configuredByUrl(false)
          traits {
            gitHubBranchDiscovery {
              strategyId(3)
            }
            localBranchTrait()
          }
        }
      }
      buildStrategies {
        excludeByIgnoreFileBranchBuildStrategy {
          ignorefilePath('.jenkinsignore')
        }
      }
    }
  }
  orphanedItemStrategy {
    discardOldItems {
      numToKeep(20)
    }
  }
  triggers {
    periodic(1)
  }
}
