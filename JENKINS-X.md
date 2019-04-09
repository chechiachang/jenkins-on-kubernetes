Jenkins X on Kubernetes
===

# Install jx

https://github.com/jenkins-x/jx

```
curl -L https://github.com/jenkins-x/jx/releases/download/v1.3.1096/jx-darwin-amd64.tar.gz | tar xzv
sudo mv jx /usr/local/bin
jx version
```

# Create GKE cluster & Get Credentials

```
CLUSTER_NAME=test
PROJECT_ID=

jx create cluster gke \
  --cluster-name=${CLUSTER_NAME} \
  --project-id=${PROJECT_ID} \
  --region=none \
  --zone=asia-east1-b \
  --machine-type=n1-standard-2 \
  --max-num-nodes=3 \
  --min-num-nodes=3 \
  --version=0.03832 \
  --default-admin-password=mySecretPassWord123 \
  --preemptible

gcloud container clusters get-credentials ${CLUSTER_NAME}
kubectl get nodes
```

# Install Jenkinx X on Kubernetes

jx install
- click 'space' to uncheck brew installation
- choose gke as provider
- enable jx to create repository on Github 
- enable Github as Git pipeline server
- Select Jenkins installation type:
  - serverless Jenkins
  - [x] Static Master Jenkins
- Pick default workload build pack
  - [x] Kubernetes Workloads: Automated CI+CD with GitOps Promotion
  - Library Workloads: CI+Release but no CD
