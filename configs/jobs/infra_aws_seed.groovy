multibranchPipelineJob('infra-aws') {
  branchSources {
    github {
      id('cyse7125-infra-aws')
      scanCredentialsId('github-app')
      repoOwner('cyse7125-su24-team09')
      repository('infra-aws')
    }
  }

  orphanedItemStrategy {
    discardOldItems {
      numToKeep(-1)
      daysToKeep(-1)
    }
  }
}
