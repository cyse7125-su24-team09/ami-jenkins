#!groovy

import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()
def username = System.getenv('JENKINS_ADMIN_USERNAME')
def password = System.getenv('JENKINS_ADMIN_PASSWORD')

// Create an admin user
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount(username, password)
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)

// Disable jenkins CLI
instance.CLI.get().setEnabled(false)

// Bypass initial jenkins setup
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

instance.save()