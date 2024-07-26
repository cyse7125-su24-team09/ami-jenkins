multibranchPipelineJob('cve-operator') {
  branchSources {
    github {
      id('cyse7125-cve-operator')
      scanCredentialsId('github-app')
      repoOwner('cyse7125-su24-team09')
      repository('cve-operator')
    }
  }

  orphanedItemStrategy {
    discardOldItems {
      numToKeep(-1)
      daysToKeep(-1)
    }
  }
}
