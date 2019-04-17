Jenkins on Kubernetes
===

This is a example project to demonstrate a working pipeline with jenkins-x on Kubernetes. The following README describes:
- Get started
- Basic operations of jx

For deployment of GKE and Jenkinx platform, check our [Install Jenkins with jx](#INSTALL.md)
For more information about jx itself, check [Jenkins-X Github Repo](https://github.com/jenkins-x/jx)

# Get-Started

```
go get -u github.com/chechiachang/jenkins-x-on-kubernetes
make install
make test
```

---
Use Jenkins Server GUI
===

http://jenkins.jx.35.187.146.68.nip.io/blue/organizations/jenkins/chechiachang%2Fjenkins-x-on-kubernetes/detail/feature-add-test/2/pipeline

---
Use jx client
===

# Get Components and Service Endpoints

```
jx get urls
Name                      URL
jenkins                   http://jenkins.jx.35.187.146.68.nip.io
jenkins-x-chartmuseum     http://chartmuseum.jx.35.187.146.68.nip.io
jenkins-x-docker-registry http://docker-registry.jx.35.187.146.68.nip.io
jenkins-x-monocular-api   http://monocular.jx.35.187.146.68.nip.io
jenkins-x-monocular-ui    http://monocular.jx.35.187.146.68.nip.io
nexus                     http://nexus.jx.35.187.146.68.nip.io
```

# Get Cluster Status

```
jx diagnose
```

# Get Applications & Pipelines

```
jx get applications
jx get pipelines
```

# Get CI Activities & build log

```
jx get activities
jx get activities --filter='jenkins-x-on-kubernetes'

jx get build log

INFO[0003] view the log at: http://jenkins.jx.35.187.146.68.nip.io/job/chechiachang/job/jenkins-x-on-kubernetes/job/feature-add-test/3/console
...
```

- http based
- Require log as Jenkins user

# Trigger Build & Check Activity

```
jx start pipeline
jx start pipeline --filter='jenkins-x-on-kubernetes/feature-add-test'

jx get activities --filter='jenkins-x-on-kubernetes'
```
