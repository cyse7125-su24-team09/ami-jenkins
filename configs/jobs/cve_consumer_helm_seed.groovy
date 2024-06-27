multibranchPipelineJob('cve-consumer-helm') {
  branchSources {
    github {
      id('cyse7125-cve-consumer-helm')
      scanCredentialsId('github-app')
      repoOwner('cyse7125-su24-team09')
      repository('helm-webapp-cve-consumer')
    }
  }

  orphanedItemStrategy {
    discardOldItems {
      numToKeep(-1)
      daysToKeep(-1)
    }
  }
}
