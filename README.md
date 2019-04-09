Turorial Jenkins on Kubernetes
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

gcloud container clusters ${CLUSTER_NAME} \
  --zone=asia-east1-b \
  --image-type=COS \
  --cluster-version=1.11.7-gke.12 \
  --node-version=1.11.7-gke.12 \
  --machine-type=n1-standard-2 \
  --max-nodes-per-pool=3 \
  --num-nodes=3 \
  --no-enable-autoscaling \
  --no-enable-autorepair \
  --no-enable-autoupgrade \
  --preemptible

jx create cluster gke \
  --cluster-name=${CLUSTER_NAME} \
  --project-id=${PROJECT_ID} \
  --region=asia-east1 \
  --zone=asia-east1-b \
  --machine-type=n1-standard-2 \
  --max-num-nodes=3 \
  --min-num-nodes=3 \
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
- serverless Jenkins vs static master Jenkins
  - choose serverless Jenkins
- Pick default workload build pack
  - [x] Kubernetes Workloads: Automated CI+CD with GitOps Promotion
  - Library Workloads: CI+Release but no CD
