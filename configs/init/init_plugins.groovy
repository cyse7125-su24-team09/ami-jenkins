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
    "github-branch-source",
    "workflow-aggregator",
    "antisamy-markup-formatter",
    "build-timeout",
    "configuration-as-code",
    "configuration-as-code-groovy",
    "credentials-binding",
    "cloudbees-folder",
    "dark-theme",
    "display-url-api",
    "docker-plugin",
    "docker-commons",
    "docker-workflow",
    "docker-java-api",
    "job-dsl",
    "golang",
    "nodejs",
    "pipeline-github-lib",
    "pipeline-graph-view",
    "pipeline-stage-view",
    "semantic-versioning-plugin",
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