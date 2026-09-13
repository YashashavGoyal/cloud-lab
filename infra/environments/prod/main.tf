# Production Environment Infrastructure Orchestrator

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}

# 1. Networking Module (VPC, Subnets, IGW, Multi-AZ NAT GWs, Route Tables)
module "networking" {
  source = "../../modules/networking"

  environment              = var.environment
  vpc_cidr                 = var.vpc_cidr
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
  availability_zones       = var.availability_zones
  single_nat_gateway       = var.single_nat_gateway

  tags = var.tags
}

# 2. Security Module (Security Groups for ALB, EC2, RDS & SSM IAM Role)
module "security" {
  source = "../../modules/security"

  environment = var.environment
  vpc_id      = module.networking.vpc_id
  app_port    = var.app_port

  tags = var.tags
}

# 3. Compute Module (Stateless EC2 Application Containers)
module "compute" {
  source = "../../modules/compute"

  environment               = var.environment
  private_app_subnet_ids    = module.networking.private_app_subnet_ids
  ec2_security_group_id     = module.security.ec2_security_group_id
  iam_instance_profile_name = module.security.ec2_iam_instance_profile_name
  instance_type             = var.instance_type
  instance_count            = var.instance_count
  app_port                  = var.app_port

  tags = var.tags
}

# 4. Database Module (Multi-AZ RDS PostgreSQL with Secrets Manager & Deletion Protection)
module "database" {
  source = "../../modules/database"

  environment           = var.environment
  private_db_subnet_ids = module.networking.private_db_subnet_ids
  db_security_group_id  = module.security.db_security_group_id
  instance_class        = var.db_instance_class
  skip_final_snapshot   = false
  deletion_protection   = var.deletion_protection

  tags = var.tags
}

# 5. Application Load Balancer Module (Public ALB, Target Group, Port 80 Listener)
module "alb" {
  source = "../../modules/alb"

  environment                = var.environment
  vpc_id                     = module.networking.vpc_id
  public_subnet_ids          = module.networking.public_subnet_ids
  alb_security_group_id      = module.security.alb_security_group_id
  ec2_instance_ids           = module.compute.instance_ids
  app_port                   = var.app_port
  enable_deletion_protection = var.deletion_protection

  tags = var.tags
}

# 6. Storage Module (Amazon S3 Bucket with Encryption, Versioning & Delete Safeguards)
module "storage" {
  source = "../../modules/storage"

  environment       = var.environment
  enable_versioning = true
  force_destroy     = false

  tags = var.tags
}

# 7. Monitoring Module (CloudWatch Log Groups, Metric Alarms & SNS Topic)
module "monitoring" {
  source = "../../modules/monitoring"

  environment            = var.environment
  alert_email            = var.alert_email
  alb_arn_suffix         = module.alb.alb_arn
  db_instance_identifier = module.database.db_instance_id

  tags = var.tags
}
