data "aws_route53_zone" "selected" {
  name         = "jotysdevsecopslab.xyz"
  private_zone = false
}

module "vpc" {
  source = "./modules/vpc"

  project_name    = var.project_name
  environment     = var.environment
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  environment        = var.environment
  cluster_role_arn   = module.iam.cluster_role_arn
  node_role_arn      = module.iam.node_role_arn
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "documentdb" {
  source = "./modules/documentdb"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = "10.0.0.0/16"
  private_subnet_ids = module.vpc.private_subnet_ids
  db_master_username = var.db_master_username
  db_master_password = var.db_master_password
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

module "acm" {
  source = "./modules/acm"

  project_name = var.project_name
  environment  = var.environment
  domain_name  = "flightly.jotysdevsecopslab.xyz"
  zone_id      = data.aws_route53_zone.selected.zone_id
}

module "alb_controller" {
  source = "./modules/alb-controller"

  project_name      = var.project_name
  environment       = var.environment
  cluster_name      = module.eks.cluster_name
  vpc_id            = module.vpc.vpc_id
  region            = var.aws_region
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url

  depends_on = [module.eks]
}

resource "kubernetes_secret" "db_secret" {
  metadata {
    name      = "flightly-db-secret"
    namespace = "default"
  }

  data = {
    MONGO_URI = "mongodb://${var.db_master_username}:${var.db_master_password}@${module.documentdb.cluster_endpoint}:27017/?tls=false&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"
  }

  depends_on = [module.eks]
}

resource "null_resource" "deploy_k8s_app" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}
      
      # Build and push images
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${module.ecr.registry_url}
      
      cd ../backend && docker build -t flightly-backend .
      docker tag flightly-backend:latest ${module.ecr.backend_repository_url}:latest
      docker push ${module.ecr.backend_repository_url}:latest
      
      cd ../frontend && docker build -t flightly-frontend .
      docker tag flightly-frontend:latest ${module.ecr.frontend_repository_url}:latest
      docker push ${module.ecr.frontend_repository_url}:latest
      
      # Apply Kustomize manifests
      cd ../ && kubectl apply -k k8s/overlays/production
    EOT
  }

resource "kubernetes_ingress_v1" "flightly" {
  metadata {
    name = "flightly-ingress"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode([{ "HTTP" = 80 }, { "HTTPS" = 443 }])
      "alb.ingress.kubernetes.io/ssl-redirect" = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = module.acm.certificate_arn
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = "flightly.jotysdevsecopslab.xyz"
      http {
        path {
          path      = "/api"
          path_type = "Prefix"
          backend {
            service {
              name = "backend"
              port {
                number = 8080
              }
            }
          }
        }
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "frontend"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [module.alb_controller, module.acm, null_resource.deploy_k8s_app]
}

resource "time_sleep" "wait_for_alb" {
  depends_on = [kubernetes_ingress_v1.flightly]

  create_duration = "60s" # Give ALB controller time to provision the ALB and populate status
}

data "kubernetes_ingress_v1" "flightly" {
  metadata {
    name      = kubernetes_ingress_v1.flightly.metadata[0].name
    namespace = kubernetes_ingress_v1.flightly.metadata[0].namespace
  }

  depends_on = [time_sleep.wait_for_alb]
}

resource "aws_route53_record" "flightly" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "flightly.jotysdevsecopslab.xyz"
  type    = "A"

  alias {
    name                   = data.kubernetes_ingress_v1.flightly.status[0].load_balancer[0].ingress[0].hostname
    zone_id                = "Z35SXDOTRQ7X7K" # Canonical Hosted Zone ID for ALBs in us-east-1
    evaluate_target_health = true
  }

  depends_on = [data.kubernetes_ingress_v1.flightly]
}

