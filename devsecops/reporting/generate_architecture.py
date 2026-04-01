import os
from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import Route53, VPC as AWSVPC
from diagrams.aws.compute import EC2 as AWSEC2
from diagrams.aws.general import Users as AWSUsers
from diagrams.onprem.vcs import Github
from diagrams.onprem.ci import GithubActions
from diagrams.aws.integration import Eventbridge
from diagrams.k8s.compute import Deployment
from diagrams.k8s.network import Ingress
from diagrams.custom import Custom

# Paths
logo_dir = "/home/jatri/Desktop/Flightly-Fly-application-K8s-Multi-Cloud/devsecops/reporting/logos"

graph_attr = {
    "splines": "ortho",
    "pad": "2.0",
    "nodesep": "1.2",
    "ranksep": "1.5",
    "fontname": "Helvetica-Bold",
    "fontsize": "24",
    "bgcolor": "white",
    "fontcolor": "#232F3E",
}

node_attr = {
    "fontname": "Helvetica-Bold",
    "fontsize": "12",
    "fontcolor": "#232F3E",
}

edge_attr = {
    "fontname": "Helvetica",
    "fontsize": "11",
    "penwidth": "2.0",
    "color": "#232F3E",
}

# High-contrast colors for white background
COLOR_GIT = "#000000"
COLOR_CI = "#1f77b4"
COLOR_SEC = "#d62728"
COLOR_DEPLOY = "#2ca02c"
COLOR_TRAFFIC = "#ff7f0e"
COLOR_SYNC = "#9467bd"

with Diagram("", show=False, 
             filename="/home/jatri/Desktop/Flightly-Fly-application-K8s-Multi-Cloud/devsecops/reporting/architecture", 
             direction="LR", graph_attr=graph_attr, node_attr=node_attr, edge_attr=edge_attr):

    developer = AWSUsers("Developers")
    github = Github("GitHub Source Code")
    trigger = Eventbridge("Webhook Trigger")

    with Cluster("AWS Infrastructure", graph_attr={"bgcolor": "#FFFDF5", "color": "#FF9900", "penwidth": "3.0", "style": "rounded,filled", "margin": "50"}):
        
        
        with Cluster("Region: AWS VPC", graph_attr={"bgcolor": "#F0F7FF", "color": "#4ABAF5", "penwidth": "3.0", "style": "rounded,filled", "margin": "40"}):
            # Using the VPC logo as an anchor inside the cluster
            vpc_logo = AWSVPC("VPC Network")
            
            with Cluster("Compute: EC2 Pro-Instance", graph_attr={"bgcolor": "#F7F9FB", "color": "#9333EA", "penwidth": "3.0", "style": "rounded,filled", "margin": "35"}):
                ec2_logo = AWSEC2("t3a.2xlarge Host")
                
                # CI/CD & Security Segment
                with Cluster("DevSecOps CI Engine", graph_attr={"bgcolor": "#E1F5FE", "color": "#1f77b4", "style": "rounded,filled", "margin": "20"}):
                    runner = GithubActions("Self-Hosted Runner")
                    
                    with Cluster("Static Security Analysis", graph_attr={"bgcolor": "#FFFFFF", "color": "#d62728", "style": "rounded,filled", "margin": "15"}):
                        sast1 = Custom("CodeQL", f"{logo_dir}/codeql.png")
                        sast2 = Custom("Semgrep", f"{logo_dir}/semgrep.png")
                        sonarqube = Custom("SonarQube", f"{logo_dir}/sonarqube.png")
                    
                    with Cluster("SCA & Compliance", graph_attr={"bgcolor": "#FFFFFF", "color": "#9467bd", "style": "rounded,filled", "margin": "15"}):
                        sca1 = Custom("Snyk", f"{logo_dir}/snyk.png")
                        sca2 = Custom("Gitleaks", f"{logo_dir}/gitleaks.png")
                        iac1 = Custom("Checkov", f"{logo_dir}/checkov.png")
                    
                    with Cluster("Artifact Security", graph_attr={"bgcolor": "#FFFFFF", "color": "#ff7f0e", "style": "rounded,filled", "margin": "15"}):
                        vuln = Custom("Trivy", f"{logo_dir}/trivy.png")
                
                # Persistence & Registries
                with Cluster("Core Storage & Registry", graph_attr={"bgcolor": "#F1F8E9", "color": "#2ca02c", "style": "rounded,filled", "margin": "20"}):
                    harbor = Custom("Harbor Registry", f"{logo_dir}/harbor.png")
                
                # Orchestration Layer
                with Cluster("k3s Kubernetes Engine", graph_attr={"bgcolor": "#FFF3E0", "color": "#FB923C", "style": "rounded,filled", "margin": "25"}):
                    ingress = Ingress("NGINX Controller")
                    argocd = Custom("Argo CD (GitOps)", f"{logo_dir}/argocd.png")
                    
                    with Cluster("Production Apps", graph_attr={"bgcolor": "#FFFFFF", "color": "#2ca02c", "style": "rounded,filled", "margin": "15"}):
                        frontend = Deployment("React Frontend")
                        backend = Deployment("Node.js Backend")
                    
                    with Cluster("DAST Testing Suite", graph_attr={"bgcolor": "#FFFFFF", "color": "#d62728", "style": "rounded,filled", "margin": "15"}):
                        zap = Custom("OWASP ZAP", f"{logo_dir}/zap.png")
                        nuclei = Custom("Nuclei Engine", f"{logo_dir}/nuclei.png")
        
        # k3s Kubernetes Engine's ingress is the target for DNS

    # High-Definition Orchestration Logic
    
    # 1. Developer Flow
    developer >> Edge(label="Git Commit", color=COLOR_GIT, style="bold") >> github
    github >> Edge(label="PUSH / PR Event", color=COLOR_GIT, style="dashed") >> trigger
    trigger >> Edge(label="Initialize Build", color=COLOR_CI, style="bold") >> runner
    
    # 2. Security Pipeline Flow
    runner >> Edge(color=COLOR_CI, label="Sec-Analysis") >> sast1
    sast1 >> Edge(style="dotted", color=COLOR_CI) >> sast2
    sast2 >> Edge(label="Gate Pass", color=COLOR_CI) >> sonarqube
    
    runner >> Edge(color=COLOR_CI, label="SCA-Scan") >> sca1
    sca1 >> Edge(style="dotted", color=COLOR_CI) >> sca2
    sca2 >> Edge(style="dotted", color=COLOR_CI) >> iac1
    
    # 3. Build & Publish Flow
    runner >> Edge(label="Docker Build", color=COLOR_GIT) >> vuln
    vuln >> Edge(label="Push Verified", color=COLOR_DEPLOY, style="bold") >> harbor
    
    # 4. GitOps Sync Flow
    argocd << Edge(label="State Tracking", style="dashed", color=COLOR_SYNC) << github
    argocd >> Edge(label="Pull Verified Artifacts", color=COLOR_SYNC) >> harbor
    argocd >> Edge(label="K8s Sync", color=COLOR_DEPLOY, style="bold") >> frontend
    argocd >> Edge(label="K8s Sync", color=COLOR_DEPLOY, style="bold") >> backend
    
    # 5. DAST Dynamic Scanning (The requested strong connection)
    runner >> Edge(label="Execute DAST", color=COLOR_SEC, style="bold") >> zap
    zap >> Edge(color=COLOR_SEC, style="bold") >> nuclei
    nuclei >> Edge(label="Live Fuzzing (DAST)", color=COLOR_SEC, style="bold", penwidth="3.0") >> ingress
    
    # 6. External Access Flow (Positioned at the bottom for recruiters' view)
    dns = Route53("Route53 DNS")
    users = Custom("End Users", f"{logo_dir}/end-users.png")
    
    users >> Edge(label="https://flightly.jotysdevsecopslab.xyz", color=COLOR_TRAFFIC, style="bold") >> dns
    dns >> Edge(color=COLOR_TRAFFIC, style="bold") >> ingress
    ingress >> frontend
    ingress >> backend
