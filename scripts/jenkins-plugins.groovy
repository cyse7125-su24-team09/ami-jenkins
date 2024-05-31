import jenkins.*
import hudson.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*;
import hudson.model.*
import jenkins.model.*
import hudson.security.*

final List<String> REQUIRED_PLUGINS = [
    "git",
    "github",
    "github-api",
    "workflow-aggregator",
    "build-timeout",
    "credentials-binding",
    "cloudbees-folder",
    "dark-theme",
    "github-branch-source",
    "pipeline-github-lib",
    "pipeline-graph-view",
    "timestamper",
    "ws-cleanup"
]

def instance = Jenkins.getInstance()

if (instance.pluginManager.plugins.collect {
  it.shortName
}.intersect(REQUIRED_PLUGINS).size() != REQUIRED_PLUGINS.size()) {
  REQUIRED_PLUGINS.collect {
    instance.updateCenter.getPlugin(it).deploy()
  }.each {
    it.get()
  }
  instance.restart()
}

println "Jenkins plugins installed successfully"