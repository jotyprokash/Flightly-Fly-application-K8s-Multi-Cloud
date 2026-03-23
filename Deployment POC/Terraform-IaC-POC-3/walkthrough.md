# Phase 3: Infrastructure as Code with Terraform

This phase acts as a natural extension of PoC 2 (which was executed manually in the AWS Console). We are taking the exact same production-grade AWS architecture (VPC, EKS, DocumentDB, ECR) and automating it using a modular Terraform structure. 

This establishes a reproducible, automated, and secure foundation for recruiter review, demonstrating IaC best practices.

## 1. Project Initialization & Validation

First, navigate into the Terraform PoC 3 directory and establish the dependencies and provider connections locally.

```bash
cd "Deployment POC/Terraform-IaC-POC-3/"
terraform init
```

📸 **Screenshot Prompt**: Take a screenshot of your terminal once initialization completes successfully, showing the green "Terraform has been successfully initialized!" message.
*(Save your screenshot locally as `terraform_init.png` in an `evidence/` subfolder here, then replace the placeholder below).*

> `![Terraform Init completed](./evidence/terraform_init.png)`

---

## 2. Infrastructure Plan (Dry-Run Safety Check)

Before generating any AWS resources or impacting cost, we run an execution plan. This checks our modular code and outputs exactly what Terraform intends to create in the cloud. It prevents human error and acts as our safety verification step.

First, securely export your sensitive database variables to avoid hardcoding them into Version Control:

```bash
export TF_VAR_db_master_username="flightlyadmin"
export TF_VAR_db_master_password="SecureFlightlyPassword123!"
```

Run the dry-run:
```bash
terraform plan -out=tfplan
```

📸 **Screenshot Prompt**: Take a screenshot of the very end of the `terraform plan` output showing the total number of resources (e.g., `Plan: 25 to add, 0 to change, 0 to destroy.`). This proves the architecture matches PoC 2 before executing.
*(Save to `evidence/terraform_plan.png`)*

> `![Terraform Plan Summary](./evidence/terraform_plan.png)`

---

## 3. Automated Provisioning (Deployment)

Once we've verified the resource plan, we can initiate the full AWS deployment.

```bash
terraform apply tfplan
```

> **Note**: EKS Cluster and DocumentDB provisioning can take approximately 10 to 15 minutes. 

📸 **Screenshot Prompt**: Once finished, capture the terminal showing `Apply complete!` and the heavily highlighted **Outputs** defined in our architecture (including VPC ID, EKS Cluster Endpoint, DocumentDB Endpoint, and the ECR Registry URLs).
*(Save to `evidence/terraform_apply.png`)*

> `![Terraform Apply Output](./evidence/terraform_apply.png)`

---

## 4. Visual Verification (AWS Console)

We will now grab screenshots from the AWS management console proving the automated architecture successfully spun up exactly as we desired.

📸 **EKS Validation Screenshot**: Navigate to the **AWS Console -> Amazon EKS -> Clusters**. Take a screenshot showing `flightly-cluster-poc3` in an *Active* state. Look closely at the Node Group and ensure it spun up exactly **4** `t3.micro` instances as configured in our module.
*(Save to `evidence/eks_console_active.png`)*

> `![EKS Active Console](./evidence/eks_console_active.png)`

📸 **DocumentDB Validation Screenshot**: Navigate to **Amazon DocumentDB -> Clusters**. Take a screenshot showing the `flightly-db-cluster-poc3` in the *Available* state.
*(Save to `evidence/docdb_console_active.png`)*

> `![DocDB Active Console](./evidence/docdb_console_active.png)`

## Value Delivered

Executing this phase demonstrates the ability to translate manual AWS architecture into an automated, version-controlled **Infrastructure-as-Code pipeline**. It creates a modular repository standard essential for modern cloud environments.
