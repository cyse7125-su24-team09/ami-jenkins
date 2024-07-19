multibranchPipelineJob('eks-autoscaler-helm') {
  branchSources {
    github {
      id('cyse7125-eks-autoscaler-helm')
      scanCredentialsId('github-app')
      repoOwner('cyse7125-su24-team09')
      repository('helm-eks-autoscaler')
    }
  }

  orphanedItemStrategy {
    discardOldItems {
      numToKeep(-1)
      daysToKeep(-1)
    }
  }
}
