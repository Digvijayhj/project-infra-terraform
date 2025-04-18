# 🏗️ project-infra-terraform

> Infrastructure-as-Code (IaC) setup for managing and provisioning environments for the **Game Room Dashboard** and any associated backend or frontend applications using Terraform, AWS EC2, and GitHub Actions CI/CD. Supports semantic versioning and blue-green deployment strategy.

---

## 📂 Directory Structure

```bash
project-infra-terraform/
├── .github/workflows/terraform.yml   # GitHub Actions CI/CD pipeline
├── .gitignore                        # Git exclusions
├── install-nginx.sh                 # NGINX bootstrap script for EC2
├── main.tf                          # Terraform config for EC2 + SG
├── outputs.tf                       # Terraform output values
├── terraform.tfvars                 # Custom input variables (local only)
├── variables.tf                     # Declared input variables
└── terraform.tfstate                # Local state file (excluded from repo)
```

---

## 🚀 Overview

This project automates the provisioning of infrastructure for applications (frontend and backend) hosted on EC2 using Terraform and GitHub Actions.

### 🔧 Key Features:
- Infrastructure provisioning using Terraform
- EC2 instance setup with Ubuntu and NGINX
- HTTP access via custom security group
- Blue-green deployment strategy for minimal downtime
- Semantic versioning for infra deployments
- CI/CD with GitHub Actions:
    - `terraform plan` on `develop`
    - `terraform apply` on `master`
    - Auto-tagging with SemVer

---

## 🔐 Setup Instructions

### 🔑 1. AWS IAM Access
- Create IAM user `terraform-user`
- Attach policy: `AdministratorAccess`
- Generate Access Key & Secret
- Configure AWS CLI:
```bash
aws configure
```

### 📦 2. Initialize Terraform
```bash
terraform init
```

### 🧪 3. Plan and Apply
```bash
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

> 💡 Use `terraform destroy` for cleanup.

### 🔒 4. GitHub Secrets
Add these in GitHub repo under **Settings → Secrets → Actions**:
- `EC2_HOST` = EC2 instance public IP
- `EC2_KEY`  = Private key contents of your `.pem` file (no headers)

---

## 📄 terraform.tfvars Sample
```hcl
region    = "us-west-2"
key_name  = "game-room-key"
zone_id   = ""  # Optional if Route53 is not used
```

---

## 📘 Deployment Strategy: Blue-Green

The pipeline deploys using a blue-green strategy:
1. Upload build to `/tmp/vite-deploy-temp`
2. Backup `/var/www/html` → `/var/www/html-old`
3. Replace `/var/www/html` with new build
4. Restart NGINX

Rollback:
```bash
sudo rm -rf /var/www/html
sudo mv /var/www/html-old /var/www/html
sudo systemctl restart nginx
```

---

## 📦 Semantic Versioning

Versions are stored as **Git tags** in the format:
```
v<major>.<minor>.<patch>
```
Examples: `v1.0.0`, `v1.0.1`, `v1.1.0`

### 🔁 Versioning Strategy
- Auto-incremented via GitHub Actions on every successful `master` deployment
- Stored in GitHub repository under Tags
- Can be viewed under: **GitHub → Tags** or via `git tag`

### Manual Initialization
```bash
git checkout master
git tag v1.0.0
git push origin v1.0.0
```

---

## ⚙️ CI/CD Pipeline Summary

| Branch    | Trigger        | Action                             |
|-----------|----------------|-------------------------------------|
| `develop` | Push/PR        | `terraform plan`                   |
| `master`  | PR merge       | `terraform apply` + SemVer tagging |

CI/CD managed in: `.github/workflows/terraform.yml`

---

## 🤝 Contribution Guidelines
- Use `develop` for new changes
- Create PRs targeting `develop`
- PRs to `master` trigger production deployments

---

## 🧑‍💻 Author
**Digvijay Hethur Jagadeesha**  
📧 hjdigvijay@gmail.com  
🌍 [GitHub](https://github.com/Digvijayhj)

---

## ❓ Support / Contact
For help or inquiries, email hjdigvijay@gmail.com or open an issue on the GitHub repo.

---

### ✅ Production-Ready
This repository implements industry-standard practices:
- Declarative infra-as-code
- Git-based SemVer versioning
- Safe deployments (blue-green)
- GitHub Actions automation
- Modular and auditable Terraform setup

