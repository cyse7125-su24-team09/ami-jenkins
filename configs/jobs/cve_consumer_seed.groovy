multibranchPipelineJob('cve-consumer') {
  branchSources {
    github {
      id('cyse7125-cve-consumer')
      scanCredentialsId('github-app')
      repoOwner('cyse7125-su24-team09')
      repository('webapp-cve-consumer')
    }
  }

  orphanedItemStrategy {
    discardOldItems {
      numToKeep(-1)
      daysToKeep(-1)
    }
  }
}
