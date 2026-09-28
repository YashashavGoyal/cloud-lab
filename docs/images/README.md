# CloudLab Deployment & Verification Screenshots

This directory contains runtime proof and verification screenshots captured from real AWS deployments and local Terraform executions of the **CloudLab** 3-Tier infrastructure.

---

## 📑 Screenshots Directory Catalog

### 1. End-to-End Execution & Application Verification

| Screenshot | File | Description |
| :--- | :--- | :--- |
| **Terraform Apply Success** | [`terraform_success_from_terminal.png`](terraform_success_from_terminal.png) | Terminal log showing `Apply complete! Resources: 52 added, 0 changed, 0 destroyed` along with all output variables (VPC ID, subnet IDs, EC2 private IPs, RDS endpoint, ALB DNS name, and SNS ARN). |
| **Live Application via ALB DNS** | [`website_preview_from_alb_dns.png`](website_preview_from_alb_dns.png) | Browser accessing `http://cloudlab-dev-alb-1742048591.us-east-1.elb.amazonaws.com`, verifying that the public ALB routes traffic to the containerized NGINX application running on private EC2 hosts. |

---

### 2. Networking Tier (VPC, Subnets, Gateways, Route Tables)

| Screenshot | File | Description |
| :--- | :--- | :--- |
| **VPC Resource Map** | [`aws_vpc_resource_map.png`](aws_vpc_resource_map.png) | AWS Console VPC Resource Map visualizing the 6 subnets across 2 Availability Zones (`us-east-1a`, `us-east-1b`), 5 route tables, Internet Gateway, and NAT Gateway. |
| **VPC Details** | [`aws_vpc.png`](aws_vpc.png) | AWS Console VPC configuration showing VPC ID, IPv4 CIDR block `10.0.0.0/16`, DNS resolution, and DNS hostnames enabled. |
| **Route Tables** | [`aws_route_tables.png`](aws_route_tables.png) | Explicit subnet associations verifying route segregation: public route table (to IGW), private app route tables (to NAT Gateway), and isolated private DB route table (no internet access). |
| **NAT Gateway** | [`aws_nat_gw.png`](aws_nat_gw.png) | NAT Gateway `cloudlab-dev-nat-gw-1` deployed in public subnet 1 with allocated Elastic IP for outbound internet connectivity from private app instances. |
| **Internet Gateway** | [`aws_ig.png`](aws_ig.png) | Internet Gateway `cloudlab-dev-igw` attached to `cloudlab-dev-vpc` providing bidirectional public connectivity for the ALB. |

---

### 3. Security Tier (Zero-Trust Firewalls)

| Screenshot | File | Description |
| :--- | :--- | :--- |
| **Security Groups Chaining** | [`aws_security_groups.png`](aws_security_groups.png) | AWS EC2 Security Groups console verifying Zero-Trust rule chaining: `cloudlab-dev-alb-sg` (port 80 from 0.0.0.0/0) -> `cloudlab-dev-ec2-sg` (port 8080 restricted to ALB SG) -> `cloudlab-dev-db-sg` (port 5432 restricted to EC2 SG with zero egress rules). |

---

### 4. Compute Tier (Private EC2 Application Hosts)

| Screenshot | File | Description |
| :--- | :--- | :--- |
| **EC2 Instances** | [`aws_ec2_instances.png`](aws_ec2_instances.png) | Both EC2 instances (`cloudlab-dev-app-ec2-1` and `cloudlab-dev-app-ec2-2`) running healthy across Multi-AZ (`us-east-1a` and `us-east-1b`) with 3/3 status checks passed and private-only IP addresses. |

---

### 5. Load Balancing Tier (Application Load Balancer & Target Group)

| Screenshot | File | Description |
| :--- | :--- | :--- |
| **ALB Resource Map** | [`aws_alb_resource_map.png`](aws_alb_resource_map.png) | End-to-end traffic distribution map showing HTTP:80 Listener -> Forwarding Rule -> Target Group (`cloudlab-dev-app-tg`) -> 2 Healthy EC2 Targets. |
| **ALB Configuration** | [`aws_alb.png`](aws_alb.png) | Details of `cloudlab-dev-alb` showing Active status, internet-facing scheme, dual-AZ public subnet attachment, and public DNS name. |
| **Target Group Health** | [`aws_target_group.png`](aws_target_group.png) | Target group details for `cloudlab-dev-app-tg` on port 8080 showing 2/2 targets registered and reporting healthy. |

---

### 6. Database Tier (Amazon RDS PostgreSQL)

| Screenshot | File | Description |
| :--- | :--- | :--- |
| **RDS PostgreSQL Instance** | [`aws_db.png`](aws_db.png) | RDS instance `cloudlab-dev-postgres` showing Available status, PostgreSQL engine, `db.t4g.micro` instance class, and public access disabled. |

---

### 7. Monitoring & Alerting Tier (CloudWatch & SNS)

| Screenshot | File | Description |
| :--- | :--- | :--- |
| **CloudWatch Alarms** | [`aws_cloudwatch_alarms.png`](aws_cloudwatch_alarms.png) | Configured CloudWatch metric alarms: `cloudlab-dev-ec2-high-cpu`, `cloudlab-dev-alb-high-5xx-errors`, and `cloudlab-dev-rds-low-free-storage` with notification actions enabled. |
| **SNS Alert Subscription** | [`aws_sns_topic_subscription.png`](aws_sns_topic_subscription.png) | Amazon SNS Console showing confirmed email subscription for topic `cloudlab-dev-alerts-topic`. |
