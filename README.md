Jenkins on Kubernetes
===

This is a example project to demonstrate a working pipeline with jenkins-x on Kubernetes.

For deployment of GKE and Jenkinx platform, check [Install Jenkins with jx](#INSTALL.md)

# Get-Started

```
go get -u github.com/chechiachang/jenkins-x-on-kubernetes
make install
make test
```

# Use Jenkins Server GUI

http://jenkins.jx.35.187.146.68.nip.io/blue/organizations/jenkins/chechiachang%2Fjenkins-x-on-kubernetes/detail/feature-add-test/2/pipeline

# Use jx client

```
jx get applications
jx get pipelines

jx get build log
```
