# Terraform PostgreSQL Database Module

- Export Secrets in shell
```shell
export TF_VAR_db_name="mydb"
export TF_VAR_db_user="admin"
export TF_VAR_db_password="123456789"
```
- Enable the API
```shell
gcloud services enable sqladmin.googleapis.com
gcloud services enable servicenetworking.googleapis.com

# Note: You need to enable the peering between the project and the google-managed-services
gcloud compute addresses create google-managed-services-default \
    --global \
    --purpose=VPC_PEERING \
    --prefix-length=24 \
    --network=terraform-global-vpc

gcloud services vpc-peerings connect \
    --service=servicenetworking.googleapis.com \
    --ranges=google-managed-services-default \
    --network=terraform-global-vpc \
    --project=playground-s-11-9246e05b
    
gcloud compute networks peerings list --network=terraform-global-vpc --project=playground-s-11-9246e05b
```

- Enable ssh from Google Web Console
```shell
create a firewall rule to allow ssh from google web console
allow this ip range from google web console
35.235.240.0/20
```

- Terraform Plan and Apply
```shell
terraform init
terraform plan -var-file="variables.tfvars"
terraform apply -var-file="variables.tfvars"
```