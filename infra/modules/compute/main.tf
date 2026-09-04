# Compute Module - Containerized EC2 Instances in Private Subnets

# 1. Fetch latest official Amazon Linux 2023 AMI dynamically
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 2. Containerized Application User Data Bootstrap Script
locals {
  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Update system packages
    dnf update -y

    # Install Docker engine
    dnf install -y docker
    systemctl enable --now docker
    usermod -aG docker ec2-user

    # Launch containerized Web App listening on port var.app_port
    docker run -d \
      --name cloudlab-app \
      --restart always \
      -p ${var.app_port}:80 \
      nginxdemos/hello

    echo "CloudLab Web App Container started successfully on port ${var.app_port}"
  EOF
}

# 3. EC2 Instance Provisioning
resource "aws_instance" "app" {
  count                  = var.instance_count
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = var.private_app_subnet_ids[count.index % length(var.private_app_subnet_ids)]
  vpc_security_group_ids = [var.ec2_security_group_id]
  iam_instance_profile   = var.iam_instance_profile_name

  # Zero public IP assignment (Strictly private instances)
  associate_public_ip_address = false

  # Enforce IMDSv2 (Instance Metadata Service v2) to prevent SSRF credential theft
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  # Encrypted EBS Root Volume
  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

    tags = merge(
      var.tags,
      {
        Name = "cloudlab-${var.environment}-ec2-root-disk-${count.index + 1}"
      }
    )
  }

  user_data = local.user_data

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-app-ec2-${count.index + 1}"
      Tier = "Application"
    }
  )
}
