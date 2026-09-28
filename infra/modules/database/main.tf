# Database Module - Multi-AZ RDS PostgreSQL with Secrets Manager Credential Storage

# 1. DB Subnet Group (Groups private DB subnets across AZs)
resource "aws_db_subnet_group" "main" {
  name        = "cloudlab-${var.environment}-db-subnet-group"
  description = "Database subnet group for CloudLab private DB subnets"
  subnet_ids  = var.private_db_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-db-subnet-group"
    }
  )
}

# 2. Custom DB Parameter Group (Enforce SSL)
resource "aws_db_parameter_group" "main" {
  name        = "cloudlab-${var.environment}-pg15-parameter-group"
  family      = "postgres15"
  description = "Custom parameter group enforcing SSL connection for PostgreSQL 15"

  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-pg15-parameter-group"
    }
  )
}

# 3. Secure Random Password Generation
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# 4. AWS Secrets Manager Secret for DB Credentials
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "cloudlab-${var.environment}-db-credentials"
  description             = "Master credentials for CloudLab RDS PostgreSQL database"
  recovery_window_in_days = 0

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-db-credentials"
    }
  )
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    engine   = "postgres"
    host     = aws_db_instance.main.address
    port     = aws_db_instance.main.port
    username = var.db_username
    password = random_password.db_password.result
    database = var.db_name
  })
}

# 5. RDS PostgreSQL Instance Provisioning
resource "aws_db_instance" "main" {
  identifier     = "cloudlab-${var.environment}-postgres"
  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db_password.result
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_security_group_id]
  parameter_group_name   = aws_db_parameter_group.main.name

  multi_az            = var.multi_az
  publicly_accessible = false

  backup_retention_period   = var.backup_retention_period
  backup_window             = "03:00-04:00"
  maintenance_window        = "Mon:04:30-Mon:05:30"
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "cloudlab-${var.environment}-postgres-final-snapshot"
  deletion_protection       = var.deletion_protection

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-postgres-db"
      Tier = "Database"
    }
  )
}
