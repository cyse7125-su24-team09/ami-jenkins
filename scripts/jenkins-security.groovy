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
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)
instance.save()

// Disable CLI
def descriptor = instance.getDescriptor("jenkins.CLI")
if (descriptor != null) {
    descriptor.get().setEnabled(false)
    descriptor.save()
}

// Enable CSRF protection
instance.setCrumbIssuer(new DefaultCrumbIssuer(true))
instance.save()

// Skip initial setup
InstallState.INITIAL_SETUP_COMPLETED.initializeState()
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)