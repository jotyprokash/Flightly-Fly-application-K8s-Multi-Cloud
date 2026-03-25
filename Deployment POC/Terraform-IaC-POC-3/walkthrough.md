# PoC 3: Full "Single-Shot" Infrastructure Automation

This Proof of Concept (PoC) demonstrates a **100% native Terraform** automation of our production-grade architecture. We have moved beyond manual scripts to a fully orchestrated "single-shot" deployment where a single `terraform apply` provisions everything from VPC to SSL-secured domain connectivity.

## Key Achievements

1.  **100% Native Terraform Orchestration**: Eliminated all external shell scripts (`deploy_app.sh`) in favor of Terraform's `helm` and `kubernetes` providers.
2.  **Automated SSL/TLS**: Automated the entire ACM certificate lifecycle, including DNS validation via Route 53.
3.  **Dynamic Traffic Management**: Native management of the AWS Load Balancer Controller and Kubernetes Ingress, ensuring the ALB is created and destroyed in the correct order.
4.  **Automated DNS Alias**: Programmatically captures the dynamic ALB DNS name and creates a Route 53 `A` record (Alias) for `flightly.jotysdevsecopslab.xyz`.
5.  **Sophisticated Readiness Logic**: Integrated `time_sleep` and status polling to ensure the Load Balancer is fully active before the deployment is finalized.
6.  **Immutable Artifacts**: Automated building and pushing of Docker images to ECR as part of the Terraform dependency graph.

## Architecture

The architecture is now fully defined as modular, interoperable code:
- **VPC Module**: Custom networking foundation.
- **EKS Module**: Managed Kubernetes with integrated IAM OIDC for secure service accounts.
- **DocumentDB Module**: Highly available database backend.
- **ACM Module**: Automated SSL/TLS certificates.
- **ALB-Controller Module**: Native Helm-based ingress management.
- **ECR Module**: Managed container registries.

## Troubleshooting & Learnings (Resolved in this iteration)

> [!TIP]
> **Single-Shot Readiness**: By using native Terraform providers and adding a 60s wait for the Ingress status, we've eliminated the "race condition" where Route 53 would try to map a non-existent ALB.
> **Zero-Orphan Destruction**: Because the Ingress is now a first-class resource in Terraform's state, `terraform destroy` correctly triggers the ALB cleanup *before* dismantling the VPC, solving the orphaned ENI/Security Group issue.

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

---
All AWS resources are managed via IaC. Total AWS Cost Impact during active runs: minimal (t3.micro/medium).

