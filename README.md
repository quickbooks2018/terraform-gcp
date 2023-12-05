# Hashicorp Terraform GCP

# Terraform Backend for state files in GCP

- Login with gcloud wih your service account
```commandline
gcloud auth activate-service-account --key-file=<PATH_TO_YOUR_SERVICE_ACCOUNT_KEY.json>
```

- Bucket creation with gsutil
```commandline
gsutil mb --project PROJECTID gs://<YOUR_BUCKET_NAME>/
gsutil mb -p playground-s-11-30224f85 gs://cloudgeeks-terraform/
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