# POC 3: 100% Native Terraform "Single-Shot" Orchestration

This Proof of Concept (PoC) represents the final evolution of the Flightly deployment strategy. We have successfully transition from the manual "click-ops" approach of PoC 2 to a **100% Native Terraform Automation**. 

A single `terraform apply` now orchestrates the entire lifecycle: provisionining the VPC, EKS Cluster, DocumentDB, ECR, and resolving complex 503 Service Unavailable errors through automated IAM and Security Group reconciliation.

---

## 🏗️ The Automation Journey

Unlike previous iterations that relied on `deploy_app.sh` or manual console interaction, PoC 3 achieves **Zero Shell Script** dependency.

### 1. Provisioning & Image Management
Terraform now natively handles the Docker build and ECR push via the `null_resource` lifecycle, ensuring that the Kubernetes manifests always point to the fresh immutable artifacts.

![Terraform Apply Complete](./evidence/apply_complete.png)
*The final "Success" moment: 100% of the infrastructure and application stack provisioned in a single automated pass.*

### 2. Infrastructure Health (AWS Native)
Our IaC ensures that the Application Load Balancer and EKS Cluster are not just "Active," but fully reconciled with the correct IAM permissions to handle production traffic.

![ALB Health Status](./evidence/alb_status.png)
*ALB Console verification: The Load Balancer is active and correctly associated with the public subnets across multiple AZs.*

### 3. Kubernetes Orchestration
The `kubernetes` and `helm` providers manage the ALB Controller and Flightly services. We implemented a sophisticated 300s `time_sleep` window with dynamic triggers to ensure the ALB DNS is fully populated before validing the Route 53 Alias mapping.

![Kubernetes Resource State](./evidence/k8s_resources.png)
*Pod and Ingress status: All components (`frontend`, `backend`) are in a healthy `Running` state, with the Ingress correctly displaying the ALB endpoint.*

### 4. The Final Gold Standard: Live Domain
The culmination of this PoC is the reachability of the application via our custom domain, fully secured with ACM-provisioned SSL.

![Live Application Availability](./evidence/live_app.png)
*Flightly is LIVE at `https://flightly.jotysdevsecopslab.xyz`. No 503 errors, no manual SSL validation, 100% automated.*

---

## 🛠️ Senior DevOps Insights

- **IAM Hardening**: Resolved a critical 503 error by broadening the ALB Controller's `AuthorizeSecurityGroupIngress` permissions to allow cross-node security group updates.
- **Race Condition Remediation**: The use of `time_sleep` and status polling ensures that Route 53 never points to an unprovisioned ALB, a common failure in less robust automation attempts.
- **State Integrity**: By including the Ingress as a native Terraform resource, we've enabled clean `terraform destroy` operations, preventing the "Orphaned ENI" issue that often plagues EKS VPC cleanup.

---

## 🧹 Cleanup
Infrastructure is dismantled gracefully via `terraform destroy`, maintaining the principle of **Cost-Efficiency** and **Ephemeral Environments**.

