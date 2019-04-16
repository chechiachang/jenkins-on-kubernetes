Jenkins X on Kubernetes
===

[Jenkins](https://jenkins.io/) is an open source automation server. [Jenkins-X (jx)](https://jenkins.io/projects/jenkins-x) is a Jenkins sub-project for Jenkins-on-Kubernetes.
This document describe hot to create a Jenkins-on-Kubernetes service on Google Kubernetes Engine(GKE) from ground zero.

---

# Install jx on Local Machine

[https://github.com/jenkins-x/jx/releases](https://github.com/jenkins-x/jx/releases)

```
JX_VERSION=v2.0.2
OS_ARCH=darwin-amd64
#OS_ARCH=linux-amd64
curl -L https://github.com/jenkins-x/jx/releases/download/"${JX_VERSION}"/jx-"${OS_ARCH}".tar.gz | tar xzv
sudo mv jx /usr/local/bin
jx version

NAME             VERSION
jx               2.0.2
git              git version 2.20.1
Operating System Mac OS X 10.14.4 build 18E226
```

# Create GKE cluster & Get Credentials

```
gcloud init
gcloud components update
```

```
CLUSTER_NAME=jenkins

gcloud container clusters create ${CLUSTER_NAME} \
  --num-nodes 1 \
  --machine-type n1-standard-2 \
  --enable-autoscaling \
  --min-nodes 1 \
  --max-nodes 2 \
  --zone asia-east1-b \
  --preemptible

# After cluster initialization, get credentials to access cluster with kubectl
gcloud container clusters get-credentials ${CLUSTER_NAME}

# Check cluster stats.
kubectl get nodes
```

# Install Jenkins Platform with jx

```
DEFAULT_USERNAME=myadmin
DEFAULT_PASSWORD=mySecretPassWord123

jx install \
  --default-admin-username=${DEFAULT_USERNAME} \
  --default-admin-password=${DEFAULT_PASSWORD} \
  --provider='gke'
```

Options:
- Enter Github user name
- Enter Github personal api token for CI/CD
- Enable Github as Git pipeline server
- Select Jenkins installation type: 
  - [x] Serverless Jenkins X Pipelines with Tekon
  - Static Master Jenkins
- Pick default workload build pack
  - [x] Kubernetes Workloads: Automated CI+CD with GitOps Promotion
  - Library Workloads: CI+Release but no CD
- Select the organization where you want to create the environment repository: 
  - chechiachang

```
Your Kubernetes context is now set to the namespace: jx
INFO[0231] To switch back to your original namespace use: jx namespace jx
INFO[0231] Or to use this context/namespace in just one terminal use: jx shell
INFO[0231] For help on switching contexts see: https://jenkins-x.io/developing/kube-context/

INFO[0231] To import existing projects into Jenkins:       jx import
INFO[0231] To create a new Spring Boot microservice:       jx create spring -d web -d actuator
INFO[0231] To create a new microservice from a quickstart: jx create quickstart
```

# Uninstall

```
jx uninstall
```
---

# Operations

jx diagnose

---

# Create jenkins-x.yml

In source code repository:

Import jx to remote jenkins-server
```
jx import --url git@github.com:chechiachang/all-go-rithm.git
```

Generate / Update jenkins-x.yml
```
jx create step
```

git commit & push

Draft create

# Check jenkins-x examples

https://github.com/jenkins-x-buildpacks/jenkins-x-kubernetes/tree/master/packs

---

PROS

CONS
Jenkinx server consumes lots memory
