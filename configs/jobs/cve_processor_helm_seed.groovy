multibranchPipelineJob('cve-processor-helm') {
  branchSources {
    github {
      id('cyse7125-cve-processor-helm')
      scanCredentialsId('github-app')
      repoOwner('cyse7125-su24-team09')
      repository('helm-webapp-cve-processor')
    }
  }

  orphanedItemStrategy {
    discardOldItems {
      numToKeep(-1)
      daysToKeep(-1)
    }
  }
}
