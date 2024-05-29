import jenkins.model.*
import hudson.model.*

final List<String> REQUIRED_PLUGINS = [
    "workflow-aggregator",
    "ws-cleanup"
]

def instance = Jenkins.getInstance()
def installedPlugins = instance.pluginManager.plugins.collect { it.shortName }
def missingPlugins = REQUIRED_PLUGINS - installedPlugins

if (!missingPlugins.isEmpty()) {
    missingPlugins.collect { plugin ->
        instance.updateCenter.getPlugin(plugin).deploy()
    }.each { 
        it.get()
    }

    instance.save()
} 

println "All required plugins are installed"
