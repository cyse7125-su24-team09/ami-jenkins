multibranchPipelineJob('cve-processor') {
  branchSources {
    github {
      id('cyse7125-cve-processor')
      scanCredentialsId('github-app')
      repoOwner('cyse7125-su24-team09')
      repository('webapp-cve-processor')
    }
  }

  orphanedItemStrategy {
    discardOldItems {
      numToKeep(-1)
      daysToKeep(-1)
    }
  }
}
