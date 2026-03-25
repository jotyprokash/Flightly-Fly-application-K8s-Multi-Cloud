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

resource "null_resource" "deploy_k8s_app" {
  depends_on = [module.eks, module.documentdb, module.ecr]

  provisioner "local-exec" {
    command = "chmod +x deploy_app.sh && bash deploy_app.sh ${module.eks.cluster_name} ${var.aws_region} ${module.ecr.frontend_repository_url} ${module.ecr.backend_repository_url} ${module.documentdb.cluster_endpoint}"
  }
}

