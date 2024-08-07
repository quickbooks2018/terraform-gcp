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

# Script: GCP Infrastructure Setup
# Description: Sets up GCP infrastructure including VPC, subnets, GKE cluster, and optionally DNS

set -euo pipefail

# Configuration
PROJECT_ID="playground-s-11-1b6e65c6"
REGION="us-central1"
ZONE="${REGION}-a"
VPC_NAME="global-vpc"
CLUSTER_NAME="gke-cluster"
DNS_NAME="test-infra.com."
ZONE_NAME="permisson-io-zone"
ENVIRONMENT="production"
SETUP_DNS=false  # Set this to true if you want to set up DNS (requires domain ownership)

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

# Function definitions
function log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

function check_prerequisites() {
    log "Checking prerequisites..."
    command -v gcloud >/dev/null 2>&1 || { log "gcloud is required but not installed. Aborting."; exit 1; }

    gcloud config set project "${PROJECT_ID}"
}

function enable_apis() {
    log "Enabling necessary APIs..."
    apis=(
        "container.googleapis.com"
        "compute.googleapis.com"
        "cloudresourcemanager.googleapis.com"
        "iam.googleapis.com"
        "monitoring.googleapis.com"
        "logging.googleapis.com"
        "containerregistry.googleapis.com"
    )

    for api in "${apis[@]}"; do
        if ! gcloud services list --enabled --filter="name:${api}" --format="value(name)" | grep -q "${api}"; then
            gcloud services enable "${api}" --quiet
            log "Enabled ${api}"
        else
            log "${api} is already enabled"
        fi
    done
}

function create_vpc() {
    log "Creating VPC and subnets..."
    if ! gcloud compute networks describe "${VPC_NAME}" &>/dev/null; then
        gcloud compute networks create "${VPC_NAME}" --subnet-mode=custom --project="${PROJECT_ID}" --quiet
        log "Created VPC ${VPC_NAME}"
    else
        log "VPC ${VPC_NAME} already exists"
    fi

    create_subnet() {
        local name=$1 cidr=$2 region=$3 type=$4
        if ! gcloud compute networks subnets describe "${name}" --region="${region}" &>/dev/null; then
            gcloud compute networks subnets create "${name}" \
                --network="${VPC_NAME}" \
                --range="${cidr}" \
                --region="${region}" \
                --enable-private-ip-google-access \
                --enable-flow-logs \
                --description="${name}" \
                --quiet
            log "Created subnet ${name}"
        else
            log "Subnet ${name} already exists"
        fi
    }

    create_subnet "${PUBLIC_SUBNET_NAME}-01" "${PUBLIC_SUBNET_1_CIDR}" "${PUBLIC_SUBNET_1_REGION}" "public"
    create_subnet "${PUBLIC_SUBNET_NAME}-02" "${PUBLIC_SUBNET_2_CIDR}" "${PUBLIC_SUBNET_2_REGION}" "public"
    create_subnet "${PUBLIC_SUBNET_NAME}-03" "${PUBLIC_SUBNET_3_CIDR}" "${PUBLIC_SUBNET_3_REGION}" "public"
    create_subnet "${PRIVATE_SUBNET_NAME}-01" "${PRIVATE_SUBNET_1_CIDR}" "${PRIVATE_SUBNET_1_REGION}" "private"
    create_subnet "${PRIVATE_SUBNET_NAME}-02" "${PRIVATE_SUBNET_2_CIDR}" "${PRIVATE_SUBNET_2_REGION}" "private"
    create_subnet "${PRIVATE_SUBNET_NAME}-03" "${PRIVATE_SUBNET_3_CIDR}" "${PRIVATE_SUBNET_3_REGION}" "private"
}

function create_nat_gateways() {
    log "Creating Cloud Routers and NAT gateways..."
    declare -A region_subnet_map=(
        ["us-west1"]="${PRIVATE_SUBNET_NAME}-03"
        ["us-east1"]="${PRIVATE_SUBNET_NAME}-02"
        ["us-central1"]="${PRIVATE_SUBNET_NAME}-01"
    )

    for region in "${!region_subnet_map[@]}"; do
        router_name="nat-router-${region}"
        nat_name="nat-gateway-${region}"
        subnet_name="${region_subnet_map[$region]}"

        if ! gcloud compute routers describe "${router_name}" --region="${region}" &>/dev/null; then
            gcloud compute routers create "${router_name}" \
                --network="${VPC_NAME}" \
                --region="${region}" \
                --quiet
            log "Created router ${router_name}"
        else
            log "Router ${router_name} already exists"
        fi

        if ! gcloud compute routers nats describe "${nat_name}" --router="${router_name}" --region="${region}" &>/dev/null; then
            if gcloud compute networks subnets describe "${subnet_name}" --region="${region}" &>/dev/null; then
                gcloud compute routers nats create "${nat_name}" \
                    --router="${router_name}" \
                    --region="${region}" \
                    --auto-allocate-nat-external-ips \
                    --nat-custom-subnet-ip-ranges="${subnet_name}" \
                    --quiet
                log "Created NAT gateway ${nat_name}"
            else
                log "Subnet ${subnet_name} not found in region ${region}. Skipping NAT gateway creation."
            fi
        else
            log "NAT gateway ${nat_name} already exists"
        fi
    done
}

function create_gke_cluster() {
    log "Creating GKE cluster..."
    if ! gcloud container clusters describe "${CLUSTER_NAME}" --zone="${ZONE}" &>/dev/null; then
        gcloud container clusters create "${CLUSTER_NAME}" \
            --project="${PROJECT_ID}" \
            --zone="${ZONE}" \
            --release-channel=stable \
            --network="${VPC_NAME}" \
            --subnetwork="${PRIVATE_SUBNET_NAME}-01" \
            --enable-ip-alias \
            --num-nodes=1 \
            --machine-type=e2-medium \
            --disk-size=50 \
            --enable-autorepair \
            --enable-autoupgrade \
            --quiet
        log "Created GKE cluster ${CLUSTER_NAME}"
    else
        log "GKE cluster ${CLUSTER_NAME} already exists"
    fi

    log "Creating node pools..."
    node_pools=(
        "stateless-apps-node-pool,stateless=true,stateless-apps-node-pool=true:NoSchedule"
        "stateful-apps-node-pool,stateful=true,stateful-apps-node-pool=true:NoSchedule"
    )

    for pool in "${node_pools[@]}"; do
        IFS=',' read -r name label taint <<< "${pool}"
        if ! gcloud container node-pools describe "${name}" --cluster="${CLUSTER_NAME}" --zone="${ZONE}" &>/dev/null; then
            gcloud container node-pools create "${name}" \
                --cluster="${CLUSTER_NAME}" \
                --zone="${ZONE}" \
                --machine-type=e2-medium \
                --num-nodes=1 \
                --enable-autoscaling \
                --min-nodes=0 \
                --max-nodes=3 \
                --node-labels="${label}" \
                --node-taints="${taint}" \
                --scopes=https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring \
                --tags="${name}" \
                --disk-type=pd-standard \
                --disk-size=10 \
                --image-type=COS_CONTAINERD \
                --quiet
            log "Created node pool ${name}"
        else
            log "Node pool ${name} already exists"
        fi
    done
}

function setup_dns() {
    if [ "${SETUP_DNS}" = true ]; then
        log "Setting up DNS..."
        if ! gcloud compute addresses describe api-static-ip --region="${REGION}" &>/dev/null; then
            gcloud compute addresses create api-static-ip \
                --project="${PROJECT_ID}" \
                --region="${REGION}" \
                --description="Static IP address for ${ENVIRONMENT} environment" \
                --quiet
            log "Created static IP address api-static-ip"
        else
            log "Static IP address api-static-ip already exists"
        fi

        log "DNS zone and record creation skipped. To set up DNS:"
        log "1. Verify ownership of the domain at http://www.google.com/webmasters/verification/"
        log "2. Use the following commands to create the zone and record:"
        log "gcloud dns managed-zones create ${ZONE_NAME} --dns-name=${DNS_NAME} --description=\"DNS zone for ${DNS_NAME}\" --visibility=public"
        STATIC_IP=$(gcloud compute addresses describe api-static-ip --region="${REGION}" --format='get(address)')
        log "gcloud dns record-sets create ${DNS_NAME} --zone=${ZONE_NAME} --type=A --ttl=300 --rrdatas=${STATIC_IP}"
    else
        log "DNS setup skipped. Set SETUP_DNS=true in the script to enable DNS setup."
    fi
}

function main() {
    check_prerequisites
    enable_apis
    create_vpc
    create_nat_gateways
    create_gke_cluster
    setup_dns
}

# Error handling and cleanup
function cleanup() {
    if [ $? -ne 0 ]; then
        log "An error occurred. Please check the output above for more details."
        log "You may need to manually clean up any partially created resources."
    fi
}

trap cleanup EXIT

# Execute main function
main

log "Infrastructure setup complete."
```

- GKE Stack delete
```bash
#!/bin/bash

# Script: GCP Infrastructure Deletion
# Description: Deletes the GCP infrastructure including GKE cluster, VPC, subnets, NAT gateways, and DNS resources

set -euo pipefail

# Configuration (same as in the setup script)
PROJECT_ID="playground-s-11-1b6e65c6"
REGION="us-central1"
ZONE="${REGION}-a"
VPC_NAME="global-vpc"
CLUSTER_NAME="gke-cluster"
DNS_NAME="test-infra.com."
ZONE_NAME="permisson-io-zone"
SETUP_DNS=false  # Set this to true if you set up DNS in the original script

# Function definitions
function log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

function check_prerequisites() {
    log "Checking prerequisites..."
    command -v gcloud >/dev/null 2>&1 || { log "gcloud is required but not installed. Aborting."; exit 1; }

    gcloud config set project "${PROJECT_ID}"
}

function delete_dns() {
    if [ "${SETUP_DNS}" = true ]; then
        log "Deleting DNS resources..."
        if gcloud dns record-sets list --zone="${ZONE_NAME}" --name="${DNS_NAME}" --type=A &>/dev/null; then
            gcloud dns record-sets delete "${DNS_NAME}" --zone="${ZONE_NAME}" --type=A --quiet
            log "Deleted DNS A record for ${DNS_NAME}"
        fi

        if gcloud dns managed-zones describe "${ZONE_NAME}" &>/dev/null; then
            gcloud dns managed-zones delete "${ZONE_NAME}" --quiet
            log "Deleted DNS zone ${ZONE_NAME}"
        fi

        if gcloud compute addresses describe api-static-ip --region="${REGION}" &>/dev/null; then
            gcloud compute addresses delete api-static-ip --region="${REGION}" --quiet
            log "Deleted static IP address api-static-ip"
        fi
    else
        log "DNS deletion skipped as it wasn't set up in the original script."
    fi
}

function delete_gke_cluster() {
    log "Deleting GKE cluster..."
    if gcloud container clusters describe "${CLUSTER_NAME}" --zone="${ZONE}" &>/dev/null; then
        gcloud container clusters delete "${CLUSTER_NAME}" --zone="${ZONE}" --quiet
        log "Deleted GKE cluster ${CLUSTER_NAME}"
    else
        log "GKE cluster ${CLUSTER_NAME} does not exist"
    fi
}

function delete_nat_gateways() {
    log "Deleting Cloud Routers and NAT gateways..."
    regions=("us-west1" "us-east1" "us-central1")

    for region in "${regions[@]}"; do
        router_name="nat-router-${region}"
        nat_name="nat-gateway-${region}"

        if gcloud compute routers nats describe "${nat_name}" --router="${router_name}" --region="${region}" &>/dev/null; then
            gcloud compute routers nats delete "${nat_name}" --router="${router_name}" --region="${region}" --quiet
            log "Deleted NAT gateway ${nat_name}"
        fi

        if gcloud compute routers describe "${router_name}" --region="${region}" &>/dev/null; then
            gcloud compute routers delete "${router_name}" --region="${region}" --quiet
            log "Deleted router ${router_name}"
        fi
    done
}

function delete_vpc() {
    log "Deleting VPC and subnets..."
    subnets=(
        "public-subnet-01" "public-subnet-02" "public-subnet-03"
        "private-subnet-01" "private-subnet-02" "private-subnet-03"
    )
    regions=("us-central1" "us-east1" "us-west1")

    for subnet in "${subnets[@]}"; do
        for region in "${regions[@]}"; do
            if gcloud compute networks subnets describe "${subnet}" --region="${region}" &>/dev/null; then
                gcloud compute networks subnets delete "${subnet}" --region="${region}" --quiet
                log "Deleted subnet ${subnet} in ${region}"
            fi
        done
    done

    if gcloud compute networks describe "${VPC_NAME}" &>/dev/null; then
        gcloud compute networks delete "${VPC_NAME}" --quiet
        log "Deleted VPC ${VPC_NAME}"
    else
        log "VPC ${VPC_NAME} does not exist"
    fi
}

function disable_apis() {
    log "Disabling APIs..."
    apis=(
        "container.googleapis.com"
        "compute.googleapis.com"
        "cloudresourcemanager.googleapis.com"
        "iam.googleapis.com"
        "monitoring.googleapis.com"
        "logging.googleapis.com"
        "containerregistry.googleapis.com"
    )

    for api in "${apis[@]}"; do
        if gcloud services list --enabled --filter="name:${api}" --format="value(name)" | grep -q "${api}"; then
            gcloud services disable "${api}" --force --quiet
            log "Disabled ${api}"
        else
            log "${api} is already disabled"
        fi
    done
}

function main() {
    check_prerequisites
    delete_dns
    delete_gke_cluster
    delete_nat_gateways
    delete_vpc
    disable_apis
}

# Error handling and cleanup
function cleanup() {
    if [ $? -ne 0 ]; then
        log "An error occurred during deletion. Please check the output above for more details."
        log "You may need to manually delete any remaining resources."
    fi
}

trap cleanup EXIT

# Execute main function
main

log "Infrastructure deletion complete."
```

- gke stack acloud-guru sandbox
```bash
#!/bin/bash

# Script: GCP Infrastructure Setup
# Description: Sets up GCP infrastructure including VPC, subnets, GKE cluster, and optionally DNS

set -euo pipefail

# Configuration
PROJECT_ID="playground-s-11-145917d3"
REGION="us-central1"
ZONE="${REGION}-a"
VPC_NAME="global-vpc"
CLUSTER_NAME="gke-cluster"
DNS_NAME="test-infra.com."
ZONE_NAME="permisson-io-zone"
ENVIRONMENT="production"
SETUP_DNS=false  # Set this to true if you want to set up DNS (requires domain ownership)

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

# Function definitions
function log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

function check_prerequisites() {
    log "Checking prerequisites..."
    command -v gcloud >/dev/null 2>&1 || { log "gcloud is required but not installed. Aborting."; exit 1; }

    gcloud config set project "${PROJECT_ID}"
}

function enable_apis() {
    log "Enabling necessary APIs..."
    apis=(
        "container.googleapis.com"
        "compute.googleapis.com"
        "cloudresourcemanager.googleapis.com"
        "iam.googleapis.com"
        "monitoring.googleapis.com"
        "logging.googleapis.com"
        "containerregistry.googleapis.com"
    )

    for api in "${apis[@]}"; do
        if ! gcloud services list --enabled --filter="name:${api}" --format="value(name)" | grep -q "${api}"; then
            gcloud services enable "${api}" --quiet
            log "Enabled ${api}"
        else
            log "${api} is already enabled"
        fi
    done
}

function create_vpc() {
    log "Creating VPC and subnets..."
    if ! gcloud compute networks describe "${VPC_NAME}" &>/dev/null; then
        gcloud compute networks create "${VPC_NAME}" --subnet-mode=custom --project="${PROJECT_ID}" --quiet
        log "Created VPC ${VPC_NAME}"
    else
        log "VPC ${VPC_NAME} already exists"
    fi

    create_subnet() {
        local name=$1 cidr=$2 region=$3 type=$4
        if ! gcloud compute networks subnets describe "${name}" --region="${region}" &>/dev/null; then
            gcloud compute networks subnets create "${name}" \
                --network="${VPC_NAME}" \
                --range="${cidr}" \
                --region="${region}" \
                --enable-private-ip-google-access \
                --enable-flow-logs \
                --description="${name}" \
                --quiet
            log "Created subnet ${name}"
        else
            log "Subnet ${name} already exists"
        fi
    }

    create_subnet "${PUBLIC_SUBNET_NAME}-01" "${PUBLIC_SUBNET_1_CIDR}" "${PUBLIC_SUBNET_1_REGION}" "public"
    create_subnet "${PUBLIC_SUBNET_NAME}-02" "${PUBLIC_SUBNET_2_CIDR}" "${PUBLIC_SUBNET_2_REGION}" "public"
    create_subnet "${PUBLIC_SUBNET_NAME}-03" "${PUBLIC_SUBNET_3_CIDR}" "${PUBLIC_SUBNET_3_REGION}" "public"
    create_subnet "${PRIVATE_SUBNET_NAME}-01" "${PRIVATE_SUBNET_1_CIDR}" "${PRIVATE_SUBNET_1_REGION}" "private"
    create_subnet "${PRIVATE_SUBNET_NAME}-02" "${PRIVATE_SUBNET_2_CIDR}" "${PRIVATE_SUBNET_2_REGION}" "private"
    create_subnet "${PRIVATE_SUBNET_NAME}-03" "${PRIVATE_SUBNET_3_CIDR}" "${PRIVATE_SUBNET_3_REGION}" "private"
}

function create_nat_gateways() {
    log "Creating Cloud Routers and NAT gateways..."
    declare -A region_subnet_map=(
        ["us-west1"]="${PRIVATE_SUBNET_NAME}-03"
        ["us-east1"]="${PRIVATE_SUBNET_NAME}-02"
        ["us-central1"]="${PRIVATE_SUBNET_NAME}-01"
    )

    for region in "${!region_subnet_map[@]}"; do
        router_name="nat-router-${region}"
        nat_name="nat-gateway-${region}"
        subnet_name="${region_subnet_map[$region]}"

        if ! gcloud compute routers describe "${router_name}" --region="${region}" &>/dev/null; then
            gcloud compute routers create "${router_name}" \
                --network="${VPC_NAME}" \
                --region="${region}" \
                --quiet
            log "Created router ${router_name}"
        else
            log "Router ${router_name} already exists"
        fi

        if ! gcloud compute routers nats describe "${nat_name}" --router="${router_name}" --region="${region}" &>/dev/null; then
            if gcloud compute networks subnets describe "${subnet_name}" --region="${region}" &>/dev/null; then
                gcloud compute routers nats create "${nat_name}" \
                    --router="${router_name}" \
                    --region="${region}" \
                    --auto-allocate-nat-external-ips \
                    --nat-custom-subnet-ip-ranges="${subnet_name}" \
                    --quiet
                log "Created NAT gateway ${nat_name}"
            else
                log "Subnet ${subnet_name} not found in region ${region}. Skipping NAT gateway creation."
            fi
        else
            log "NAT gateway ${nat_name} already exists"
        fi
    done
}

function create_gke_cluster() {
    log "Creating GKE cluster..."
    if ! gcloud container clusters describe "${CLUSTER_NAME}" --zone="${ZONE}" &>/dev/null; then
        gcloud container clusters create "${CLUSTER_NAME}" \
            --project="${PROJECT_ID}" \
            --zone="${ZONE}" \
            --release-channel=stable \
            --network="${VPC_NAME}" \
            --subnetwork="${PRIVATE_SUBNET_NAME}-01" \
            --enable-ip-alias \
            --num-nodes=3 \
            --machine-type=e2-medium \
            --disk-size=50 \
            --enable-autorepair \
            --enable-autoupgrade \
            --quiet
        log "Created GKE cluster ${CLUSTER_NAME}"
    else
        log "GKE cluster ${CLUSTER_NAME} already exists"
    fi

    log "Creating node pool..."
    node_pool_name="main-node-pool"
    if ! gcloud container node-pools describe "${node_pool_name}" --cluster="${CLUSTER_NAME}" --zone="${ZONE}" &>/dev/null; then
        gcloud container node-pools create "${node_pool_name}" \
            --cluster="${CLUSTER_NAME}" \
            --zone="${ZONE}" \
            --machine-type=e2-medium \
            --num-nodes=1 \
            --node-labels="environment=${ENVIRONMENT},app=main" \
            --scopes=https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring \
            --tags="${node_pool_name}" \
            --disk-type=pd-standard \
            --disk-size=10 \
            --image-type=COS_CONTAINERD \
            --quiet
        log "Created node pool ${node_pool_name}"
    else
        log "Node pool ${node_pool_name} already exists"
    fi
}

function setup_dns() {
    if [ "${SETUP_DNS}" = true ]; then
        log "Setting up DNS..."
        if ! gcloud compute addresses describe api-static-ip --region="${REGION}" &>/dev/null; then
            gcloud compute addresses create api-static-ip \
                --project="${PROJECT_ID}" \
                --region="${REGION}" \
                --description="Static IP address for ${ENVIRONMENT} environment" \
                --quiet
            log "Created static IP address api-static-ip"
        else
            log "Static IP address api-static-ip already exists"
        fi

        log "DNS zone and record creation skipped. To set up DNS:"
        log "1. Verify ownership of the domain at http://www.google.com/webmasters/verification/"
        log "2. Use the following commands to create the zone and record:"
        log "gcloud dns managed-zones create ${ZONE_NAME} --dns-name=${DNS_NAME} --description=\"DNS zone for ${DNS_NAME}\" --visibility=public"
        STATIC_IP=$(gcloud compute addresses describe api-static-ip --region="${REGION}" --format='get(address)')
        log "gcloud dns record-sets create ${DNS_NAME} --zone=${ZONE_NAME} --type=A --ttl=300 --rrdatas=${STATIC_IP}"
    else
        log "DNS setup skipped. Set SETUP_DNS=true in the script to enable DNS setup."
    fi
}

function main() {
    check_prerequisites
    enable_apis
    create_vpc
    create_nat_gateways
    create_gke_cluster
    setup_dns
}

# Error handling and cleanup
function cleanup() {
    if [ $? -ne 0 ]; then
        log "An error occurred. Please check the output above for more details."
        log "You may need to manually clean up any partially created resources."
    fi
}

trap cleanup EXIT

# Execute main function
main

log "Infrastructure setup complete."
```

- gke delete sand-box acloudguru
```bash
#!/bin/bash

# Script: GCP Infrastructure Deletion
# Description: Deletes the GCP infrastructure including GKE cluster, VPC, subnets, and DNS resources

set -euo pipefail

# Configuration
PROJECT_ID="playground-s-11-1b6e65c6"
REGION="us-central1"
ZONE="${REGION}-a"
VPC_NAME="global-vpc"
CLUSTER_NAME="gke-cluster"
DNS_NAME="test-infra.com."
ZONE_NAME="permisson-io-zone"
SETUP_DNS=false  # Set this to true if you set up DNS

function log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

function delete_gke_cluster() {
    log "Deleting GKE cluster..."
    if gcloud container clusters describe "${CLUSTER_NAME}" --zone="${ZONE}" &>/dev/null; then
        gcloud container clusters delete "${CLUSTER_NAME}" \
            --zone="${ZONE}" \
            --quiet
        log "Deleted GKE cluster ${CLUSTER_NAME}"
    else
        log "GKE cluster ${CLUSTER_NAME} does not exist"
    fi
}

function delete_nat_gateways() {
    log "Deleting Cloud NAT gateways and routers..."
    regions=("us-west1" "us-east1" "us-central1")
    for region in "${regions[@]}"; do
        router_name="nat-router-${region}"
        nat_name="nat-gateway-${region}"

        if gcloud compute routers nats describe "${nat_name}" --router="${router_name}" --region="${region}" &>/dev/null; then
            gcloud compute routers nats delete "${nat_name}" \
                --router="${router_name}" \
                --region="${region}" \
                --quiet
            log "Deleted NAT gateway ${nat_name}"
        else
            log "NAT gateway ${nat_name} does not exist"
        fi

        if gcloud compute routers describe "${router_name}" --region="${region}" &>/dev/null; then
            gcloud compute routers delete "${router_name}" \
                --region="${region}" \
                --quiet
            log "Deleted router ${router_name}"
        else
            log "Router ${router_name} does not exist"
        fi
    done
}

function delete_vpc() {
    log "Deleting VPC and subnets..."
    subnets=(
        "${REGION}/public-subnet-01"
        "us-east1/public-subnet-02"
        "us-west1/public-subnet-03"
        "${REGION}/private-subnet-01"
        "us-east1/private-subnet-02"
        "us-west1/private-subnet-03"
    )

    for subnet in "${subnets[@]}"; do
        IFS='/' read -r subnet_region subnet_name <<< "${subnet}"
        if gcloud compute networks subnets describe "${subnet_name}" --region="${subnet_region}" &>/dev/null; then
            gcloud compute networks subnets delete "${subnet_name}" \
                --region="${subnet_region}" \
                --quiet
            log "Deleted subnet ${subnet_name}"
        else
            log "Subnet ${subnet_name} does not exist"
        fi
    done

    if gcloud compute networks describe "${VPC_NAME}" &>/dev/null; then
        gcloud compute networks delete "${VPC_NAME}" --quiet
        log "Deleted VPC ${VPC_NAME}"
    else
        log "VPC ${VPC_NAME} does not exist"
    fi
}

function delete_dns() {
    if [ "${SETUP_DNS}" = true ]; then
        log "Deleting DNS resources..."
        if gcloud compute addresses describe api-static-ip --region="${REGION}" &>/dev/null; then
            gcloud compute addresses delete api-static-ip \
                --region="${REGION}" \
                --quiet
            log "Deleted static IP address api-static-ip"
        else
            log "Static IP address api-static-ip does not exist"
        fi

        if gcloud dns managed-zones describe "${ZONE_NAME}" &>/dev/null; then
            gcloud dns record-sets delete "${DNS_NAME}" \
                --zone="${ZONE_NAME}" \
                --type=A \
                --quiet
            log "Deleted DNS record ${DNS_NAME}"

            gcloud dns managed-zones delete "${ZONE_NAME}" --quiet
            log "Deleted DNS zone ${ZONE_NAME}"
        else
            log "DNS zone ${ZONE_NAME} does not exist"
        fi
    else
        log "DNS deletion skipped. Set SETUP_DNS=true in the script to delete DNS resources."
    fi
}

function main() {
    delete_gke_cluster
    delete_nat_gateways
    delete_vpc
    delete_dns
}

# Error handling
function cleanup() {
    if [ $? -ne 0 ]; then
        log "An error occurred during deletion. Please check the output above for more details."
        log "You may need to manually delete any remaining resources."
    fi
}

trap cleanup EXIT

# Execute main function
main

log "Infrastructure deletion complete."
```

- gke acloudguru sandbox (without hosted zone)
```bash
#!/bin/bash

# Script: GCP Infrastructure Setup
# Description: Sets up GCP infrastructure including VPC, subnets, GKE cluster

set -euo pipefail

# Configuration
PROJECT_ID="playground-s-11-145917d3"
REGION="us-central1"
ZONE="${REGION}-a"
VPC_NAME="global-vpc"
CLUSTER_NAME="gke-cluster"
ENVIRONMENT="production"

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

# Function definitions
function log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

function check_prerequisites() {
    log "Checking prerequisites..."
    command -v gcloud >/dev/null 2>&1 || { log "gcloud is required but not installed. Aborting."; exit 1; }

    gcloud config set project "${PROJECT_ID}"
}

function enable_apis() {
    log "Enabling necessary APIs..."
    apis=(
        "container.googleapis.com"
        "compute.googleapis.com"
        "cloudresourcemanager.googleapis.com"
        "iam.googleapis.com"
        "monitoring.googleapis.com"
        "logging.googleapis.com"
        "containerregistry.googleapis.com"
    )

    for api in "${apis[@]}"; do
        if ! gcloud services list --enabled --filter="name:${api}" --format="value(name)" | grep -q "${api}"; then
            gcloud services enable "${api}" --quiet
            log "Enabled ${api}"
        else
            log "${api} is already enabled"
        fi
    done
}

function create_vpc() {
    log "Creating VPC and subnets..."
    if ! gcloud compute networks describe "${VPC_NAME}" &>/dev/null; then
        gcloud compute networks create "${VPC_NAME}" --subnet-mode=custom --project="${PROJECT_ID}" --quiet
        log "Created VPC ${VPC_NAME}"
    else
        log "VPC ${VPC_NAME} already exists"
    fi

    create_subnet() {
        local name=$1 cidr=$2 region=$3 type=$4
        if ! gcloud compute networks subnets describe "${name}" --region="${region}" &>/dev/null; then
            gcloud compute networks subnets create "${name}" \
                --network="${VPC_NAME}" \
                --range="${cidr}" \
                --region="${region}" \
                --enable-private-ip-google-access \
                --enable-flow-logs \
                --description="${name}" \
                --quiet
            log "Created subnet ${name}"
        else
            log "Subnet ${name} already exists"
        fi
    }

    create_subnet "${PUBLIC_SUBNET_NAME}-01" "${PUBLIC_SUBNET_1_CIDR}" "${PUBLIC_SUBNET_1_REGION}" "public"
    create_subnet "${PUBLIC_SUBNET_NAME}-02" "${PUBLIC_SUBNET_2_CIDR}" "${PUBLIC_SUBNET_2_REGION}" "public"
    create_subnet "${PUBLIC_SUBNET_NAME}-03" "${PUBLIC_SUBNET_3_CIDR}" "${PUBLIC_SUBNET_3_REGION}" "public"
    create_subnet "${PRIVATE_SUBNET_NAME}-01" "${PRIVATE_SUBNET_1_CIDR}" "${PRIVATE_SUBNET_1_REGION}" "private"
    create_subnet "${PRIVATE_SUBNET_NAME}-02" "${PRIVATE_SUBNET_2_CIDR}" "${PRIVATE_SUBNET_2_REGION}" "private"
    create_subnet "${PRIVATE_SUBNET_NAME}-03" "${PRIVATE_SUBNET_3_CIDR}" "${PRIVATE_SUBNET_3_REGION}" "private"
}

function create_nat_gateways() {
    log "Creating Cloud Routers and NAT gateways..."
    declare -A region_subnet_map=(
        ["us-west1"]="${PRIVATE_SUBNET_NAME}-03"
        ["us-east1"]="${PRIVATE_SUBNET_NAME}-02"
        ["us-central1"]="${PRIVATE_SUBNET_NAME}-01"
    )

    for region in "${!region_subnet_map[@]}"; do
        router_name="nat-router-${region}"
        nat_name="nat-gateway-${region}"
        subnet_name="${region_subnet_map[$region]}"

        if ! gcloud compute routers describe "${router_name}" --region="${region}" &>/dev/null; then
            gcloud compute routers create "${router_name}" \
                --network="${VPC_NAME}" \
                --region="${region}" \
                --quiet
            log "Created router ${router_name}"
        else
            log "Router ${router_name} already exists"
        fi

        if ! gcloud compute routers nats describe "${nat_name}" --router="${router_name}" --region="${region}" &>/dev/null; then
            if gcloud compute networks subnets describe "${subnet_name}" --region="${region}" &>/dev/null; then
                gcloud compute routers nats create "${nat_name}" \
                    --router="${router_name}" \
                    --region="${region}" \
                    --auto-allocate-nat-external-ips \
                    --nat-custom-subnet-ip-ranges="${subnet_name}" \
                    --quiet
                log "Created NAT gateway ${nat_name}"
            else
                log "Subnet ${subnet_name} not found in region ${region}. Skipping NAT gateway creation."
            fi
        else
            log "NAT gateway ${nat_name} already exists"
        fi
    done
}

function create_gke_cluster() {
    log "Creating GKE cluster..."
    if ! gcloud container clusters describe "${CLUSTER_NAME}" --zone="${ZONE}" &>/dev/null; then
        gcloud container clusters create "${CLUSTER_NAME}" \
            --project="${PROJECT_ID}" \
            --zone="${ZONE}" \
            --release-channel=stable \
            --network="${VPC_NAME}" \
            --subnetwork="${PRIVATE_SUBNET_NAME}-01" \
            --enable-ip-alias \
            --num-nodes=4 \
            --machine-type=e2-medium \
            --disk-size=10 \
            --enable-autorepair \
            --enable-autoupgrade \
            --quiet
        log "Created GKE cluster ${CLUSTER_NAME}"
    else
        log "GKE cluster ${CLUSTER_NAME} already exists"
    fi

    log "Creating node pool..."
    node_pool_name="main-node-pool"
    if ! gcloud container node-pools describe "${node_pool_name}" --cluster="${CLUSTER_NAME}" --zone="${ZONE}" &>/dev/null; then
        gcloud container node-pools create "${node_pool_name}" \
            --cluster="${CLUSTER_NAME}" \
            --zone="${ZONE}" \
            --machine-type=e2-medium \
            --num-nodes=3 \
            --node-labels="environment=${ENVIRONMENT},app=main" \
            --scopes=https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring \
            --tags="${node_pool_name}" \
            --disk-type=pd-standard \
            --disk-size=10 \
            --image-type=COS_CONTAINERD \
            --quiet
        log "Created node pool ${node_pool_name}"
    else
        log "Node pool ${node_pool_name} already exists"
    fi
}

function main() {
    check_prerequisites
    enable_apis
    create_vpc
    create_nat_gateways
    create_gke_cluster
}

# Error handling and cleanup
function cleanup() {
    if [ $? -ne 0 ]; then
        log "An error occurred. Please check the output above for more details."
        log "You may need to manually clean up any partially created resources."
    fi
}

trap cleanup EXIT

# Execute main function
main

log "Infrastructure setup complete."
```
