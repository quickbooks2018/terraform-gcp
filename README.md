# Hashicorp Terraform GCP

# Terraform Backend for state files in GCP

- Login with gcloud wih your service account
```commandline
gcloud auth activate-service-account --key-file=<PATH_TO_YOUR_SERVICE_ACCOUNT_KEY.json>
```

- Bucket creation with gsutil
```commandline
gsutil mb --project PROJECTID gs://<YOUR_BUCKET_NAME>/
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
export CLOUDSDK_CORE_PROJECT=playground-s-11-47a8ae67
gcloud services enable compute.googleapis.com
```

- vpc regional and global mode https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network

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