# PoC 4: Production DevSecOps Platform (Security & GitOps)

This Proof of Concept (PoC) represents the terminal state of the Flightly infrastructure—a mature, production-grade **DevSecOps Platform**. We have moved beyond simple automation (IaC) into **Continuous Security** and **GitOps-driven** reconciliations.

The goal is to demonstrate a "Secure by Design" approach where every commit is automatically vetted for vulnerabilities before reaching our EKS production environment.

---

## Architecture Overview

The following diagram illustrates the complete DevSecOps ecosystem. It focuses on the **Security Pipeline Flow** and the **GitOps Sync Flow** that keeps our Kubernetes cluster in sync with our repository state.

![Production DevSecOps Architecture](../docs/assets/architecture.png)

### Key Architectural Pillars:
1.  **Distributed Runner Node**: Using a dedicated EC2 host to run self-hosted GitHub Actions runners, keeping build traffic within our VPC.
2.  **Multilayered Security Gates**: Integrating SAST, SCA, and DAST at the pipeline level.
3.  **Immutable Registry**: Harbor acts as the secure, scanned artifact repository.
4.  **GitOps Orchestration**: Argo CD ensures the cluster state matches the `git` manifests 100% of the time, preventing configuration drift.

---

## 1. Automated Security Pipeline (The Gates)

Our CI pipeline (GitHub Actions) doesn't just build code; it enforces a security standard.

### Phase A: Static Analysis (SAST)
- **CodeQL**: Deep semantic analysis to find common coding flaws and logic vulnerabilities.
- **Semgrep**: Fast, pattern-matched security scanning for Node.js and React best practices.
- **SonarQube**: Measuring overall code quality, coverage, and security hotspots.

### Phase B: Software Composition Analysis (SCA)
- **Snyk**: Identifying vulnerable dependencies in `package.json` and providing automated fix suggestions.
- **Checkov**: Scanning our Terraform and Kubernetes manifests for misconfigurations (e.g., running as root, missing resource limits).
- **Gitleaks**: Ensuring no secrets or AWS keys are accidentally committed to the repository.

### Phase C: Container Security
- **Trivy**: Scanning the final Docker images for OS-level vulnerabilities before they are pushed to the registry.

---

## 2. Artifact Management (Harbor)

We transitioned from standard ECR to **Harbor** for advanced security features:
- **Vulnerability Scanning**: Automated re-scans of stored images.
- **Content Trust**: Ensuring only signed and verified images are deployed.
- **Project Isolation**: Granular RBAC for different environments.

---

## 3. GitOps Deployment (Argo CD)

Instead of using `kubectl apply` from the CI runner, we use **Argo CD** to manage the Kubernetes state.

- **Sync Policy**: Argo CD monitors our `kubernetes/` directory. When a change is pushed, Argo pulls the new state into EKS.
- **Drift Detection**: If a manual change is made in the cluster, Argo CD detects it and (optionally) reverts it to the source of truth.

---

## 4. Dynamic Security Testing (DAST)

While the application is running in the `Production Apps` cluster, we execute dynamic tests:
- **OWASP ZAP**: Simulating real-world attacks (SQL injection, XSS) against the live `flightly.jotysdevsecopslab.xyz` endpoint.
- **Nuclei**: Running fast template-based scans to find known CVEs in the exposed infrastructure.

---

## 🚀 Impact for Recruiters

This architecture showcases:
- **Senior-level understanding** of the full software development lifecycle (SDLC).
- **Security-First Mindset**: Not just deploying apps, but protecting them.
- **Infrastructure Maturity**: Using enterprise tools (Argo CD, Harbor, Snyk) rather than basic scripts.
- **Cost & Performance Optimization**: Using self-hosted infrastructure to manage large security scanning workloads efficiently.

---

👉 **Live Secure Endpoint**: [https://flightly.jotysdevsecopslab.xyz](https://flightly.jotysdevsecopslab.xyz)
