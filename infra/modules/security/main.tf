# Security Module - Security Groups (ALB, EC2, RDS) and IAM SSM Roles

# 1. Application Load Balancer Security Group
resource "aws_security_group" "alb" {
  name        = "cloudlab-${var.environment}-alb-sg"
  description = "Controls HTTP/HTTPS ingress traffic to Application Load Balancer"
  vpc_id      = var.vpc_id

  # Ingress Rule: Allow HTTP (Port 80) from anywhere on the Internet
  ingress {
    description      = "Allow HTTP from public internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Ingress Rule: Allow HTTPS (Port 443) from anywhere on the Internet
  ingress {
    description      = "Allow HTTPS from public internet"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-alb-sg"
    }
  )
}

# 2. EC2 Application Instance Security Group
resource "aws_security_group" "ec2" {
  name        = "cloudlab-${var.environment}-ec2-sg"
  description = "Security group for EC2 instances behind ALB"
  vpc_id      = var.vpc_id

  # Ingress Rule: Allow traffic ONLY from ALB Security Group on app_port (8080)
  ingress {
    description     = "Allow app port from ALB Security Group"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Egress Rule: Allow all outbound internet traffic via NAT Gateway
  egress {
    description      = "Allow all outbound internet traffic via NAT Gateway"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-ec2-sg"
    }
  )
}

# Add Egress Rule to ALB Security Group pointing to EC2 Security Group
resource "aws_security_group_rule" "alb_egress_to_ec2" {
  type                     = "egress"
  description              = "Allow outbound from ALB to EC2 app port"
  from_port                = var.app_port
  to_port                  = var.app_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = aws_security_group.ec2.id
}

# 3. RDS PostgreSQL Security Group
resource "aws_security_group" "db" {
  name        = "cloudlab-${var.environment}-db-sg"
  description = "Isolated security group for RDS PostgreSQL database"
  vpc_id      = var.vpc_id

  # Ingress Rule: Allow PostgreSQL (Port 5432) ONLY from EC2 Security Group
  ingress {
    description     = "Allow PostgreSQL access strictly from EC2 instances"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  # Zero Egress rules (RDS database cannot initiate any outbound connections)

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-db-sg"
    }
  )
}

# 4. IAM Role for AWS Systems Manager (SSM) Session Manager (SSH-less management)
resource "aws_iam_role" "ec2_ssm" {
  name = "cloudlab-${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-ec2-ssm-role"
    }
  )
}

# Attach AWS Managed Policy for SSM Session Manager
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# 5. IAM Instance Profile for EC2 Instances
resource "aws_iam_instance_profile" "ec2" {
  name = "cloudlab-${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2_ssm.name

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-ec2-instance-profile"
    }
  )
}
