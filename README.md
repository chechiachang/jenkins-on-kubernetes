Jenkins X on Kubernetes
===

[Jenkins](https://jenkins.io/) is an open source automation server. [Jenkins-X (jx)](https://jenkins.io/projects/jenkins-x) is a Jenkins sub-project for Jenkins-on-Kubernetes.
This document describe hot to create a Jenkins-on-Kubernetes service on Google Kubernetes Engine(GKE) from ground zero.

---

# Create GKE cluster & Get Credentials

```
gcloud init
gcloud components update
```

```
CLUSTER_NAME=jenkins-server
#CLUSTER_NAME=jenkins-serverless

gcloud container clusters create ${CLUSTER_NAME} \
  --num-nodes 1 \
  --machine-type n1-standard-4 \
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

# Install jx on Local Machine

[Jenkins X Release](https://github.com/jenkins-x/jx/releases](https://github.com/jenkins-x/jx/releases)

```
JX_VERSION=v2.0.2
OS_ARCH=darwin-amd64
#OS_ARCH=linux-amd64
curl -L https://github.com/jenkins-x/jx/releases/download/"${JX_VERSION}"/jx-"${OS_ARCH}".tar.gz | tar xzv
sudo mv jx /usr/local/bin
jx version

NAME               VERSION
jx                 2.0.2
Kubernetes cluster v1.11.7-gke.12
kubectl            v1.11.9-dispatcher
helm client        v2.11.0+g2e55dbe
helm server        v2.11.0+g2e55dbe
git                git version 2.20.1
Operating System   Mac OS X 10.14.4 build 18E226
```

# (Option 1) Install Serverless Jenkins Pipeline

```
DEFAULT_PASSWORD=mySecretPassWord123

jx install \
  --default-admin-password=${DEFAULT_PASSWORD} \
  --provider='gke'
```

Options:
- Enter Github user name
- Enter Github personal api token for CI/CD
- Enable Github as Git pipeline server
- Select Jenkins installation type: 
  - [x] Serverless Jenkins X Pipelines with Tekon
  - [] Static Master Jenkins
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

# (Option 2) Install Static Jenkins Server

```
DEFAULT_PASSWORD=mySecretPassWord123

jx install \
  --default-admin-password=${DEFAULT_PASSWORD} \
  --provider='gke'
```

Options:
- Enter Github user name
- Enter Github personal api token for CI/CD
- Enable Github as Git pipeline server
- Select Jenkins installation type: 
  - [] Serverless Jenkins X Pipelines with Tekon
  - [x] Static Master Jenkins
- Pick default workload build pack
  - [x] Kubernetes Workloads: Automated CI+CD with GitOps Promotion
  - Library Workloads: CI+Release but no CD
- Select the organization where you want to create the environment repository: 
  - chechiachang

```
INFO[0465]
Your Kubernetes context is now set to the namespace: jx
INFO[0465] To switch back to your original namespace use: jx namespace default
INFO[0465] Or to use this context/namespace in just one terminal use: jx shell
INFO[0465] For help on switching contexts see: https://jenkins-x.io/developing/kube-context/

INFO[0465] To import existing projects into Jenkins:       jx import
INFO[0465] To create a new Spring Boot microservice:       jx create spring -d web -d actuator
INFO[0465] To create a new microservice from a quickstart: jx create quickstart
```

Access Static Jenkins Server through Domain with username and password
Domain http://jenkins.jx.11.22.33.44.nip.io/

# Uninstall

```
jx uninstall
# rm -rf ~/.jx
```
---
Setup Application CI/CD Pipeline
===

# Create Quickstart Repository

```
kubectl get pods --namespace jx --watch
```

```
# cd workspace
jx create quickstart
```

- Which organisation do you want to use? chechiachang
- Enter the new repository name:  serverless-jenkins-quickstart
- select the quickstart you wish to create  [Use arrows to move, type to filter]
  angular-io-quickstart
  aspnet-app
  dlang-http
> golang-http
  jenkins-cwp-quickstart
  jenkins-quickstart
  node-http

```
INFO[0121] Watch pipeline activity via:    jx get activity -f serverless-jenkins-quickstart -w
INFO[0121] Browse the pipeline log via:    jx get build logs chechiachang/serverless-jenkins-quickstart/master
INFO[0121] Open the Jenkins console via    jx console
INFO[0121] You can list the pipelines via: jx get pipelines
INFO[0121] When the pipeline is complete:  jx get applications
```

# Check log of the first run

```
jx logs pipeline
```

# Add Step to Pipeline

Add a setup step for pullrequest
```
cd serverless-jenkins-quickstart
jx create step --pipeline pullrequest \
  --lifecycle setup \
  --mode replace \
  --sh "echo hello world"
```

Validate pipeline step for each modification
```
jx step validate
```

A build-pack pod started after git push. Watch pod status with kubectl.
```
kubectl get pods --namespace jx --watch
```

# Check Build Status on Prow (Serverless)

http://deck.jx.130.211.245.13.nip.io/
Login with username and password

---

# Import Existing Repository

In source code repository:

Import jx to remote jenkins-server. This will apply a Jenkinsfile to repository by default
```
jx import --url git@github.com:chechiachang/serverless-jenkins-quickstart.git
```

Update jenkins-x.yml
```
jx create step
```

git commit & push

---

# Trouble Shooting

### Failed to get jx resources

```
jx get pipelines
```

Make sure your jx (or kubectl) context is with the correct GKE and namespace
```
kc config set-context gke_my-project_asia-east1-b_jenkins \
  --namespace=jx
```

---

# Check jenkins-x examples

https://github.com/jenkins-x-buildpacks/jenkins-x-kubernetes/tree/master/packs

---

# Operations

jx diagnose

---
