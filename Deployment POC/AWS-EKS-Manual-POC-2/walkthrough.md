# Production-Grade AWS EKS Deployment PoC
## Flightly: Multi-Cloud Flight Application

This Proof of Concept (PoC) documents the manual provisioning of a production-ready, highly available architecture on AWS. It demonstrates the fundamental infrastructure components required to run containerized microservices securely and at scale.

---

## 🏗️ Architecture Overview

The following diagram represents the complete cloud-native architecture provisioned in this PoC. It illustrates the traffic flow from the public internet through to application pods in private subnets, backed by a managed database.

![Flightly AWS EKS Production Architecture](./evidence/architecture_diagram.png)

### Key Infrastructure Pillars:
- **Security**: All compute (EKS Nodes) and data (DocumentDB) reside in **Private Subnets**.
- **Edge**: Route 53 DNS integrates with AWS Certificate Manager (ACM) for end-to-end SSL/TLS.
- **Traffic**: AWS Application Load Balancer (ALB) serves as the entry point, managed by the AWS Load Balancer Controller.
- **Persistence**: Managed Amazon DocumentDB for high availability and automated scaling.

---

## Phase 1: Infrastructure Foundations

### 1. Network & VPC Preparation
A custom VPC was architected to isolate compute resources from the public internet.

![EKS VPC Architecture](./evidence/vpc_architecture.png)

- **Service**: Amazon VPC
- **Configuration**:
  - **Topology**: 2 Availability Zones for high availability.
  - **Subnet Strategy**: 2 Public Subnets (Ingress) and 2 Private Subnets (Workloads/Data).
  - **Gateway**: 1 NAT Gateway to allow private instances to reach the internet for updates.
  - **CIDR**: `10.0.0.0/16`

![VPC Creation Summary](./evidence/vpc_Summary.png)

---

### 2. Container Image Registry (Amazon ECR)
We established a secure, private registry for our microservices.

- **Action**: Provisioned private ECR repositories for both Frontend and Backend services.
- **CI/CD Logic**: Manually performed build-tag-push flow to simulate a delivery pipeline.

#### Backend Registry Pipeline:
![Backend CLI Step 1](./evidence/backend_cli_1.png)
![Backend CLI Step 2](./evidence/backend_cli_2.png)
![Backend CLI Step 3](./evidence/backend_cli_3.png)

#### Frontend Registry Pipeline:
![Frontend CLI Step 1](./evidence/frontend_cli_1.png)
![Frontend CLI Step 2](./evidence/frontend_cli_2.png)

#### ECR Dashboard Verification:
![ECR Backend Dashboard](./evidence/ecr_dashboard_BE.png)
![ECR Frontend Dashboard](./evidence/ecr_dashboard_FE.png)

---

### 3. Database Provisioning (Amazon DocumentDB)
To ensure data durability and performance, we opted for a managed DocumentDB cluster.

- **Service**: Amazon DocumentDB (MongoDB compatible).
- **Security Layer**: 
  - Placed in a dedicated **Subnet Group** across private subnets.
  - **Security Group (Firewall)**: Restricted to accept inbound TCP `27017` only from the VPC CIDR.

![DocumentDB Subnet Group](./evidence/documentdb_subnet_group.png)
![DocumentDB Setup 1](./evidence/documentdb_setup_1.png)
![DocumentDB Available](./evidence/documentdb_cluster_available.png)
![DocumentDB Security Group](./evidence/documentdb_security_group.png)

---

## Phase 2: Kubernetes Compute Layer

### 4. EKS Control Plane Setup
Provisioning the managed Kubernetes control plane with fine-grained IAM permissions.

- **IAM Role**: Created `flightly-eks-cluster-role` with `AmazonEKSClusterPolicy`.
- **EKS Config**: Cluster version `1.35` with Public/Private endpoint access enabled.
- **Note**: "Auto Mode" was disabled to maintain manual control over networking and compute.

![EKS IAM Role](./evidence/eks_iam_role.png)
![EKS Cluster Setup 1](./evidence/eks_cluster_setup.png)
![EKS Cluster Setup 2](./evidence/eks_cluster_setup_2.png)

---

### 5. Managed Node Groups (Worker Nodes)
Adding compute capacity while adhering to cost-effective burstable instance types.

- **Instance Type**: `t3.micro` (Optimized for PoC costs).
- **Networking**: Nodes are strictly placed in **Private Subnets** to prevent direct external access.
- **Desired Capacity**: 2 Nodes across 2 AZs.

![EKS Node IAM Role](./evidence/eks_node_iam_role.png)
![EKS Node Group Setup](./evidence/eks_node_group_setup.png)
![EKS Nodes Active](./evidence/eks_node_active.png)

---

### 6. Cluster Governance & Authentication
Configuring local machine access to the remote cluster via the AWS CLI.

```bash
aws eks update-kubeconfig --region us-east-1 --name flightly-cluster
kubectl get nodes
```

![EKS Terminal Access](./evidence/eks_terminal_nodes.png)

---

## Phase 3: Application Delivery & Security

### 7. AWS Load Balancer Controller Installation
Integrating EKS with native AWS Load Balancing services.

1. **IAM OIDC Provider**: Configured the cluster to support Service Account IAM roles (IRSA).
2. **Controller Deployment**: Installed the AWS Load Balancer Controller via **Helm**.

![ALB Setup 1](./evidence/alb_terminal_setup_1.png)
![ALB Setup 2](./evidence/alb_terminal_setup_2.png)

---

### 8. Production Deployment & Secret Management
Applying production-ready Kubernetes manifests and overlaying AWS-specific configurations.

- **Kustomize Overlays**: Used to inject ECR image URIs and specify the `alb` Ingress class.
- **Secrets Management**: Manually injected DocumentDB credentials as a `kubectl` secret to avoid hardcoding.

![K8s Secret Created](./evidence/k8s_secret_created.png)
![K8s Manifests Applied](./evidence/k8s_manifests_applied.png)
![K8s Resources Applied](./evidence/k8s_resources_applied.png)

---

### 9. Edge Networking: Route 53 & SSL/TLS
Finalizing the public-facing entry point with custom domain and HTTPS.

- **Service**: AWS Certificate Manager (ACM) & Route 53.
- **SSL Certificate**: Provisioned a public certificate for `flightly.jotysdevsecopslab.xyz`.
- **DNS Record**: Created an **A-record Alias** pointing the domain to the ALB DNS name.

#### Certificate Issuance (ACM):
![ACM Request Start](./evidence/acm_request_start.png)
![ACM Certificate Issued](./evidence/acm_certificate_issued.png)

#### Ingress Re-Configuration (Phase B):
Updated Ingress annotations to enable **SSL Redirect (HTTP -> HTTPS)** and attach the `certificate-arn`.

![HTTPS Ingress Applied](./evidence/https_ingress_applied.png)
![Route 53 DNS Record](./evidence/route53_dns_record.png)

---

## 🚀 The Result: Application Live
The application is now fully provisioned and securely serving traffic at:
**[https://flightly.jotysdevsecopslab.xyz](https://flightly.jotysdevsecopslab.xyz)**

### Verification:
The site is live with a valid SSL padlock and a fully operational Frontend-to-Backend-to-Database flow.

![HTTPS Live](./evidence/https_live_png.png)
![Live Application](./evidence/live_domain.png)
