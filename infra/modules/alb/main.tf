# Application Load Balancer (ALB) Module

# 1. Application Load Balancer Provisioning
resource "aws_lb" "main" {
  name               = "cloudlab-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  drop_invalid_header_fields = true

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-alb"
    }
  )
}

# 2. Target Group for Backend EC2 Application Instances
resource "aws_lb_target_group" "app" {
  name                 = "cloudlab-${var.environment}-app-tg"
  port                 = var.app_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "instance"
  deregistration_delay = 30

  health_check {
    enabled             = true
    path                = var.health_check_path
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-app-tg"
    }
  )
}

# 3. Target Group Attachment for Backend EC2 Instances
resource "aws_lb_target_group_attachment" "app" {
  count            = length(var.ec2_instance_ids)
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = var.ec2_instance_ids[count.index]
  port             = var.app_port
}

# 4. HTTP Listener (Port 80) Forwarding to Target Group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = merge(
    var.tags,
    {
      Name = "cloudlab-${var.environment}-alb-http-listener"
    }
  )
}
