# PoC 3: Full Infrastructure Automation with Terraform

This Proof of Concept (PoC) demonstrates automating our production-grade architecture using **Terraform**, moving beyond manual provisioning to clear, reproducible Infrastructure as Code (IaC).

## Key Achievements

1.  **Terraform Automation**: Replaced manual EKS, VPC, and DocumentDB creation with a modular Terraform suite.
2.  **Secret Management**: Automated the creation of Kubernetes secrets for DocumentDB connectivity using the provisioned cluster endpoint.
3.  **ALB Controller Integration**: Automated the deployment of the AWS Load Balancer Controller within the EKS cluster.
4.  **Application Deployment**: Successfully built, pushed, and deployed the frontend and backend microservices to the new cluster.
5.  **Domain Connectivity**: Provisioned an ALB and updated the Route 53 `A` record for `flightly.jotysdevsecopslab.xyz` to point to the new infrastructure.
6.  **Full Cleanup**: Successfully performed a `terraform destroy` (with manual cleanup of orphaned ALB/ENIs) to ensure zero ongoing costs.

## Architecture

The architecture remains identical to PoC 2 but is now fully defined in code:
- **VPC Module**: Custom VPC with public/private subnets, NAT Gateway, and Internet Gateway.
- **EKS Module**: Managed Kubernetes cluster with managed node groups (t3.micro).
- **DocumentDB Module**: Highly available DocumentDB cluster with automated subnet group and security group management.
- **ECR Module**: Private container registries for the microservices.

## Troubleshooting & Learnings

> [!TIP]
> **ALB Controller Readiness**: We discovered that the ALB controller needs a few extra seconds to be fully operational before `kubectl apply -k` is run. Adding a `rollout status` check fixed the webhook connectivity errors.

> [!IMPORTANT]
> **Orphaned Resources**: When destroying the infrastructure, the ALB controller might sometimes leave behind Security Groups or Load Balancers if the pods are terminated before they can clean up. We manually resolved this to unblock the VPC deletion.

## Proof of Work

### 1. Terraform Initialization & Plan
Infrastructure was initialized and validated via dry-run:
![Terraform Init](./evidence/terraform_init.png)
![Terraform Plan](./evidence/terraform_plan.png)

### 2. Live Infrastructure Status (AWS Console)
The following screenshots confirm the automated provisioning of our core architecture:

**EKS Cluster Active**:
![EKS Active](./evidence/eks_console_active.png)

**DocumentDB Cluster Available**:
![DocumentDB Active](./evidence/docdb_console_active.png)

## Cleanup
All AWS resources have been destroyed via `terraform destroy`.
**Total AWS Cost Impact: $0.**

