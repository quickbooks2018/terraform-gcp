# Hashicorp Terraform GCP

# Terraform Backend for state files in GCP

- Login with gcloud wih your service account
```commandline
gcloud auth activate-service-account --key-file=<PATH_TO_YOUR_SERVICE_ACCOUNT_KEY.json>
```

- Bucket creation with gsutil
```commandline
gsutil mb --project PROJECTID gs://<YOUR_BUCKET_NAME>/
gcloud config set project playground-s-11-7666c625
gsutil mb gs://cloudgeeks-terraform-1/


gsutil mb -p playground-s-11-7666c625 gs://cloudgeeks-terraform-1/
```

- Gcp List buckets
```commandline
export GOOGLE_APPLICATION_CREDENTIALS="<PATH_TO_YOUR_SERVICE_ACCOUNT_KEY.json>"
export GOOGLE_APPLICATION_CREDENTIALS=/mnt/gcp/gcp.json
export PROJECT_ID=playground-s-11-7666c625
gsutil ls -p playground-s-11-d1ce4ef2
```

- Enable versioning for the bucket
```commandline
gsutil versioning set on gs://<YOUR_BUCKET_NAME>/
gsutil versioning set on gs://cloudgeeks-terraform/
```

- Provider configuration
```commandline
credentials = file("<PATH_TO_YOUR_SERVICE_ACCOUNT_KEY.json>")
project     = "<YOUR_PROJECT_ID>"
region      = "<YOUR_REGION>"
export GOOGLE_APPLICATION_CREDENTIALS="<PATH_TO_YOUR_SERVICE_ACCOUNT_KEY.json>"
export GOOGLE_APPLICATION_CREDENTIALS=/mnt/gcp/gcp.json
export GOOGLE_PROJECT=playground-s-11-47a8ae67
make sure to enable gcp api

gcloud config set project VALUE
gcloud config set project playground-s-11-7666c625

export CLOUDSDK_CORE_PROJECT=playground-s-11-47a8ae67
gcloud services enable compute.googleapis.com
```

- vpc regional and global mode https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network

- GKE Enale Required APIS
```bash
gcloud services enable container.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable logging.googleapis.com
```

- GCP Enable APIs
```commandline
gcloud services enable compute.googleapis.com --project=project-id
gcloud services enable iam.googleapis.com --project=project-id
gcloud services enable cloudresourcemanager.googleapis.com --project=project-id
gcloud services enable dns.googleapis.com --project=project-id
gcloud services enable sqladmin.googleapis.com --project=project-id
gcloud services enable storage-api.googleapis.com --project=project-id
gcloud services enable storage-component.googleapis.com --project=project-id
gcloud services enable cloudkms.googleapis.com --project=project-id
gcloud services enable cloudfunctions.googleapis.com --project=project-id
gcloud services enable cloudbuild.googleapis.com --project=project-id
gcloud services enable container.googleapis.com --project=project-id
gcloud services enable containerregistry.googleapis.com --project=project-id
gcloud services enable servicenetworking.googleapis.com --project=project-id
gcloud services enable cloudresourcemanager.googleapis.com --project=project-id
```

- Gcloud Cli to create a custom network
```commandline
gcloud compute networks create <NETWORK_NAME> --subnet-mode=custom
gcloud compute networks subnets create <SUBNET_NAME> --network=<NETWORK_NAME> --range=<CIDR_RANGE> --region=<REGION>
gcloud compute firewall-rules create <FIREWALL_RULE_NAME> --network=<NETWORK_NAME> --allow=<PROTOCOL>:<PORT_RANGE> --source-ranges=<CIDR_RANGE>
```

- Gcloud Cli to create a custom network sample and two subnets located in different regions
```commandline
gcloud compute networks create mynetwork --subnet-mode=custom
gcloud compute networks subnets create mynetwork-us --network=mynetwork --range=10.10.0.0/16 --region=us-east1
gcloud compute networks subnets create mynetwork-eu --network=mynetwork --range=10.20.0.0/16 --region=europe-west1
gcloud compute firewall-rules create mynetwork-allow-icmp --network=mynetwork --allow=icmp
gcloud compute firewall-rules create mynetwork-allow-internal --network=mynetwork --allow=udp:53,tcp:53,icmp
gcloud compute firewall-rules create mynetwork-allow-rdp --network=mynetwork --allow=tcp:3389
gcloud compute firewall-rules create mynetwork-allow-ssh --network=mynetwork --allow=tcp:22
```

- Create a VM instance with gcloud cli in zone us-east1-b
```commandline
gcloud compute instances create myinstance --zone=us-east1-b --machine-type=n2-standard-2 --subnet=mynetwork-us
```
- Create a VM instance with gcloud cli in zone europe-west1-b
```commandline
gcloud compute instances create myinstance --zone=europe-west1-b --machine-type=n2-standard-2 --subnet=mynetwork-eu
```

### tfvars file
```commandline
terraform plan -var-file="variables.tfvars" -out=tfplan
terraform show tfplan
terraform apply -var-file="variables.tfvars"
```

- GKE Stack with bash
```bash
#!/bin/bash

set -xe

# Set environment variables
PROJECT_ID="playground-s-11-f22bc6a8"
REGION="us-central1"
VPC_NAME="terraform-global-vpc"

gcloud config set project $PROJECT_ID

# Public subnets
PUBLIC_SUBNET_NAME="public-subnet"
PUBLIC_SUBNET_1_CIDR="10.10.0.0/16"
PUBLIC_SUBNET_1_REGION="us-central1"
PUBLIC_SUBNET_2_CIDR="20.20.0.0/16"
PUBLIC_SUBNET_2_REGION="us-east1"
PUBLIC_SUBNET_3_CIDR="30.30.0.0/16"
PUBLIC_SUBNET_3_REGION="us-west1"

# Private subnets
PRIVATE_SUBNET_NAME="private-subnet"
PRIVATE_SUBNET_1_CIDR="10.50.0.0/16"
PRIVATE_SUBNET_1_REGION="us-central1"
PRIVATE_SUBNET_2_CIDR="10.60.0.0/16"
PRIVATE_SUBNET_2_REGION="us-east1"
PRIVATE_SUBNET_3_CIDR="10.70.0.0/16"
PRIVATE_SUBNET_3_REGION="us-west1"

# Enable necessary services
gcloud services enable container.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable logging.googleapis.com

# Create VPC
gcloud compute networks create $VPC_NAME --subnet-mode=custom --project=$PROJECT_ID

# Create public subnets
gcloud compute networks subnets create ${PUBLIC_SUBNET_NAME}-01 \
  --network=$VPC_NAME \
  --range=$PUBLIC_SUBNET_1_CIDR \
  --region=$PUBLIC_SUBNET_1_REGION \
  --enable-private-ip-google-access \
  --enable-flow-logs \
  --description="${PUBLIC_SUBNET_NAME}-01"

gcloud compute networks subnets create ${PUBLIC_SUBNET_NAME}-02 \
  --network=$VPC_NAME \
  --range=$PUBLIC_SUBNET_2_CIDR \
  --region=$PUBLIC_SUBNET_2_REGION \
  --enable-private-ip-google-access \
  --enable-flow-logs \
  --description="${PUBLIC_SUBNET_NAME}-02"

gcloud compute networks subnets create ${PUBLIC_SUBNET_NAME}-03 \
  --network=$VPC_NAME \
  --range=$PUBLIC_SUBNET_3_CIDR \
  --region=$PUBLIC_SUBNET_3_REGION \
  --enable-private-ip-google-access \
  --enable-flow-logs \
  --description="${PUBLIC_SUBNET_NAME}-03"

# Create private subnets
gcloud compute networks subnets create ${PRIVATE_SUBNET_NAME}-01 \
  --network=$VPC_NAME \
  --range=$PRIVATE_SUBNET_1_CIDR \
  --region=$PRIVATE_SUBNET_1_REGION \
  --enable-private-ip-google-access \
  --enable-flow-logs \
  --description="${PRIVATE_SUBNET_NAME}-01"

gcloud compute networks subnets create ${PRIVATE_SUBNET_NAME}-02 \
  --network=$VPC_NAME \
  --range=$PRIVATE_SUBNET_2_CIDR \
  --region=$PRIVATE_SUBNET_2_REGION \
  --enable-private-ip-google-access \
  --enable-flow-logs \
  --description="${PRIVATE_SUBNET_NAME}-02"

gcloud compute networks subnets create ${PRIVATE_SUBNET_NAME}-03 \
  --network=$VPC_NAME \
  --range=$PRIVATE_SUBNET_3_CIDR \
  --region=$PRIVATE_SUBNET_3_REGION \
  --enable-private-ip-google-access \
  --enable-flow-logs \
  --description="${PRIVATE_SUBNET_NAME}-03"

# Create Cloud Routers
gcloud compute routers create nat-router-us-west1 \
  --network=$VPC_NAME \
  --region=us-west1

gcloud compute routers create nat-router-us-east1 \
  --network=$VPC_NAME \
  --region=us-east1

gcloud compute routers create nat-router-us-central1 \
  --network=$VPC_NAME \
  --region=us-central1

# Create Cloud NAT configurations
gcloud compute routers nats create nat-gateway-us-west1 \
  --router=nat-router-us-west1 \
  --region=us-west1 \
  --auto-allocate-nat-external-ips \
  --nat-custom-subnet-ip-ranges=private-subnet-03

gcloud compute routers nats create nat-gateway-us-east1 \
  --router=nat-router-us-east1 \
  --region=us-east1 \
  --auto-allocate-nat-external-ips \
  --nat-custom-subnet-ip-ranges=private-subnet-02

gcloud compute routers nats create nat-gateway-us-central1 \
  --router=nat-router-us-central1 \
  --region=us-central1 \
  --auto-allocate-nat-external-ips \
  --nat-custom-subnet-ip-ranges=private-subnet-01

# Create the GKE cluster with reduced resource requirements
gcloud container clusters create gke-us-central1-cluster-01 \
  --project=$PROJECT_ID \
  --region=$REGION \
  --release-channel=stable \
  --network=$VPC_NAME \
  --subnetwork=${PRIVATE_SUBNET_NAME}-01 \
  --enable-ip-alias \
  --node-locations=${REGION}-a,${REGION}-b,${REGION}-c \
  --num-nodes=1 \
  --machine-type=e2-medium \
  --disk-size=50 \
  --enable-autorepair \
  --enable-autoupgrade

# Create node pools with reduced resource requirements
gcloud container node-pools create stateless-apps-node-pool \
  --cluster=gke-us-central1-cluster-01 \
  --region=$REGION \
  --machine-type=e2-medium \
  --num-nodes=1 \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=2 \
  --node-labels=stateless=true \
  --node-taints=stateless-apps-node-pool=true:NoSchedule \
  --scopes=https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring \
  --tags=stateless-apps-node-pool \
  --disk-type=pd-standard \
  --disk-size=50 \
  --image-type=COS_CONTAINERD

gcloud container node-pools create stateful-apps-node-pool \
  --cluster=gke-us-central1-cluster-01 \
  --region=$REGION \
  --machine-type=e2-medium \
  --num-nodes=1 \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=2 \
  --node-labels=stateful=true \
  --node-taints=stateful-apps-node-pool=true:NoSchedule \
  --scopes=https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring \
  --tags=stateful-apps-node-pool \
  --disk-type=pd-standard \
  --disk-size=50 \
  --image-type=COS_CONTAINERD
```

- GKE Stack delete
```bash
#!/bin/bash

set -x

PROJECT_ID="playground-s-11-f22bc6a8"
VPC_NAME="terraform-global-vpc"

gcloud config set project $PROJECT_ID

# Delete Cloud NAT configurations
gcloud compute routers nats delete nat-gateway-us-west1 --router=nat-router-us-west1 --region=us-west1 -q
gcloud compute routers nats delete nat-gateway-us-east1 --router=nat-router-us-east1 --region=us-east1 -q
gcloud compute routers nats delete nat-gateway-us-central1 --router=nat-router-us-central1 --region=us-central1 -q

# Delete Cloud Routers
gcloud compute routers delete nat-router-us-west1 --region=us-west1 -q
gcloud compute routers delete nat-router-us-east1 --region=us-east1 -q
gcloud compute routers delete nat-router-us-central1 --region=us-central1 -q

# Delete subnets
gcloud compute networks subnets delete public-subnet-01 --region=us-central1 -q
gcloud compute networks subnets delete public-subnet-02 --region=us-east1 -q
gcloud compute networks subnets delete public-subnet-03 --region=us-west1 -q
gcloud compute networks subnets delete private-subnet-01 --region=us-central1 -q
gcloud compute networks subnets delete private-subnet-02 --region=us-east1 -q
gcloud compute networks subnets delete private-subnet-03 --region=us-west1 -q

# Delete firewall rules (if any)
# Uncomment and modify the following line if you have specific firewall rules to delete
# gcloud compute firewall-rules delete <FIREWALL_RULE_NAME> -q

# Delete routes (if any)
# Uncomment and modify the following line if you have specific routes to delete
# gcloud compute routes delete <ROUTE_NAME> -q

# Delete the VPC network
gcloud compute networks delete $VPC_NAME -q

echo "VPC and associated resources have been deleted successfully."
```
