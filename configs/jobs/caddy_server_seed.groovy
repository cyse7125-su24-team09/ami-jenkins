multibranchPipelineJob('caddy-server') {
  branchSources {
    github {
      id('cyse7125-caddy-server')
      scanCredentialsId('github-app')
      repoOwner('cyse7125-su24-team09')
      repository('static-site')
    }
  }

  orphanedItemStrategy {
    discardOldItems {
      numToKeep(-1)
      daysToKeep(-1)
    }
  }
}
