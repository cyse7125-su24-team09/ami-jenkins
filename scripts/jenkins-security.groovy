#!groovy

import jenkins.model.*
import jenkins.install.*;
import hudson.security.*
import hudson.util.*;
import hudson.security.csrf.DefaultCrumbIssuer;

def instance = Jenkins.getInstance()

// Create an initial admin user
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('JENKINS_ADMIN_USERNAME', 'JENKINS_ADMIN_PASSWORD')
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()

// Disable CLI
instance.CLI.get().setEnabled(false)
instance.save()

// Skip initial setup
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)