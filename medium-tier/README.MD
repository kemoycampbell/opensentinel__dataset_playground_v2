# Project

This is a terraform that contain reusable modules for AWS services.

# Production/Wordpress
This Terraform configuration provisions an EC2 instance and an RDS instance, then automatically deploys WordPress on the EC2 instance using the RDS credentials.

## How to Run
Non-sensitive configurations are stored in:  
`production/_<filename>.auto.tfvars`  

### **Setting Up Credentials**  
You need to provide sensitive credentials before running Terraform. There are two options:  

#### **Option 1: Use a Secure `.auto.tfvars` File**  
Create a file named `_credentials.auto.tfvars` (excluded from Git) with the following content:  

```hcl
credentials = {
  db_password  = "<your_database_password>"
  db_username  = "<your_database_username>"
  ssh_key_name = "<your_ssh_key_name>"
}
```
#### **Option 1:Option 2: Pass Credentials via terminal**
Alternatively, create a .tfvars file with the same credentials and pass it explicitly when running Terraform:
