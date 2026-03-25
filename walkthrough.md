# POC 3: Native Terraform "Single-Shot" Deployment Walkthrough

Successfully achieved a **100% Native Terraform "Single-Shot" Deployment**. The entire Flightly application stack—from VPC to DNS mapping—is orchestrated by code.

## 🚀 Deployment Status: SUCCESS
The application is LIVE and reachable via the custom domain.

- **Domain**: [https://flightly.jotysdevsecopslab.xyz](https://flightly.jotysdevsecopslab.xyz)
- **Automation Level**: 100% (Native Terraform providers)

---

## 📸 Final Evidence
- **Terraform Apply**: `Deployment POC/Terraform-IaC-POC-3/evidence/apply_complete.png`
- **ALB Health**: `Deployment POC/Terraform-IaC-POC-3/evidence/alb_status.png`
- **K8s State**: `Deployment POC/Terraform-IaC-POC-3/evidence/k8s_resources.png`
- **Live App**: `Deployment POC/Terraform-IaC-POC-3/evidence/live_app.png`

---

## 🛠️ Design Highlights
*   **Native IAM**: Managed internal ALB Controller policy.
*   **Zero Scripts**: Removed `deploy_app.sh` in favor of native `null_resource` + `kubernetes` providers.
*   **Robust Wait Logic**: 300s window for ALB/DNS propagation.

---

## 🧹 Cleanup
Infrastructure destroyed via `terraform destroy` after evidence verification.
