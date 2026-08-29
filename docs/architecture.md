# CloudLab — AWS Architecture Specification

## Stage 1: The Blank VPC (Virtual Private Cloud)

When you open AWS, your account has zero isolated networks. 

The first thing we create is a **VPC** (`10.0.0.0/16`). Think of a VPC as a giant virtual boundary fence inside AWS where all your cloud resources will live.

```mermaid
flowchart TD
    subgraph AWSCloud["AWS Region (us-east-1)"]
        subgraph VPC["VPC (CIDR: 10.0.0.0/16) - Total 65,536 IPs"]
            EmptySpace["(Empty Network - Completely Isolated from the Internet)"]
        end
    end
```

---

## Stage 2: Connecting the VPC to the Internet (Internet Gateway)

A blank VPC cannot talk to the Internet. To fix this, we attach an **Internet Gateway (IGW)** to the VPC boundary.

```mermaid
flowchart TD
    Internet["🌐 Public Internet"]
    
    subgraph AWSCloud["AWS Region (us-east-1)"]
        subgraph VPC["VPC (10.0.0.0/16)"]
            IGW["Internet Gateway (IGW)"]
            EmptySpace["Internal VPC Space"]
        end
    end

    Internet <--> IGW
    IGW <--> EmptySpace
```

---

## Stage 3: Building Availability Zone A (AZ-A)

Now we enter datacenter #1 (**`us-east-1a`**). We divide our IP space into 3 subnets stacked by security level:

1. **Public Subnet AZ-A (`10.0.1.0/24`)**: Connected to IGW. Holds **ALB Node A** and **NAT Gateway A**.
2. **Private App Subnet AZ-A (`10.0.11.0/24`)**: No public IP. Holds **EC2 Instance 1**. Routes outbound traffic through NAT Gateway A.
3. **Private DB Subnet AZ-A (`10.0.21.0/24`)**: Completely isolated. Holds **RDS Primary PostgreSQL**.

```mermaid
flowchart TD
    Internet["🌐 Public Internet"]

    subgraph AWSCloud["AWS Region (us-east-1)"]
        subgraph VPC["VPC (10.0.0.0/16)"]
            IGW["Internet Gateway (IGW)"]

            subgraph AZA["Availability Zone A (us-east-1a)"]
                subgraph PublicAZA["Public Subnet AZ-A (10.0.1.0/24)"]
                    ALB_A["ALB Node A"]
                    NAT_A["NAT Gateway A"]
                end

                subgraph PrivateAppAZA["Private App Subnet AZ-A (10.0.11.0/24)"]
                    EC2_A["EC2 App Instance 1"]
                end

                subgraph PrivateDBAZA["Private DB Subnet AZ-A (10.0.21.0/24)"]
                    RDS_Primary[("RDS PostgreSQL Primary")]
                end
            end

        end
    end

    Internet <--> IGW
    IGW <--> PublicAZA
    EC2_A -.->|Outbound Internet via NAT| NAT_A
    NAT_A -.-> IGW
    EC2_A -->|Port 5432| RDS_Primary
```

---

## Stage 4: Adding Availability Zone B (AZ-B) for High Availability

If datacenter `us-east-1a` catches fire or loses power, our single-AZ system goes down! 

To prevent downtime, we add datacenter #2 (**`us-east-1b`**) and duplicate the exact same subnet structure.

```mermaid
flowchart TD
    subgraph AWSCloud["AWS Region (us-east-1)"]
        subgraph VPC["VPC (10.0.0.0/16)"]

            subgraph AZA["AZ-A (us-east-1a)"]
                PublicAZA["Public Subnet AZ-A\n(10.0.1.0/24)"]
                PrivateAppAZA["Private App Subnet AZ-A\n(10.0.11.0/24)"]
                PrivateDBAZA["Private DB Subnet AZ-A\n(10.0.21.0/24)"]
            end

            subgraph AZB["AZ-B (us-east-1b)"]
                PublicAZB["Public Subnet AZ-B\n(10.0.2.0/24)"]
                PrivateAppAZB["Private App Subnet AZ-B\n(10.0.12.0/24)"]
                PrivateDBAZB["Private DB Subnet AZ-B\n(10.0.22.0/24)"]
            end

        end
    end
```

---

## Stage 5: The Final Master Architecture (Complete Traffic Connections)

Now we connect all components across both AZs into a unified, high-availability system:

```mermaid
flowchart TD
    subgraph InternetSpace["Public Internet"]
        Client["🌐 Users / Clients"]
    end

    subgraph AWSCloud["AWS Region (us-east-1)"]
        subgraph VPC["VPC (10.0.0.0/16)"]
            IGW["Internet Gateway (IGW)"]

            subgraph AZA["Availability Zone A (us-east-1a)"]
                subgraph PublicAZA["Public Subnet AZ-A (10.0.1.0/24)"]
                    ALB_A["ALB Node A"]
                    NAT_A["NAT Gateway A"]
                end

                subgraph PrivateAppAZA["Private App Subnet AZ-A (10.0.11.0/24)"]
                    EC2_A["EC2 Instance 1"]
                end

                subgraph PrivateDBAZA["Private DB Subnet AZ-A (10.0.21.0/24)"]
                    RDS_Primary[("RDS Primary")]
                end
            end

            subgraph AZB["Availability Zone B (us-east-1b)"]
                subgraph PublicAZB["Public Subnet AZ-B (10.0.2.0/24)"]
                    ALB_B["ALB Node B"]
                    NAT_B["NAT Gateway B"]
                end

                subgraph PrivateAppAZB["Private App Subnet AZ-B (10.0.12.0/24)"]
                    EC2_B["EC2 Instance 2"]
                end

                subgraph PrivateDBAZB["Private DB Subnet AZ-B (10.0.22.0/24)"]
                    RDS_Standby[("RDS Standby")]
                end
            end

        end
    end

    %% Inbound Flow
    Client -->|HTTP Port 80| IGW
    IGW --> ALB_A
    IGW --> ALB_B

    %% Load Balancing to EC2
    ALB_A -->|Port 8080| EC2_A
    ALB_A -->|Port 8080| EC2_B
    ALB_B -->|Port 8080| EC2_A
    ALB_B -->|Port 8080| EC2_B

    %% Database Operations
    EC2_A -->|Port 5432| RDS_Primary
    EC2_B -->|Port 5432| RDS_Primary
    RDS_Primary == Multi-AZ Sync ==> RDS_Standby

    %% Outbound Internet Updates
    EC2_A -.->|Outbound| NAT_A -.-> IGW
    EC2_B -.->|Outbound| NAT_B -.-> IGW
```

---

## Subnet & IP Address Allocation Matrix

| Subnet Name | Zone | Subnet Type | CIDR Block | Usable IPs | Internet Route |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `public-subnet-1` | `us-east-1a` | Public | `10.0.1.0/24` | 251 | Internet Gateway |
| `public-subnet-2` | `us-east-1b` | Public | `10.0.2.0/24` | 251 | Internet Gateway |
| `private-app-subnet-1` | `us-east-1a` | Private App | `10.0.11.0/24` | 251 | NAT Gateway |
| `private-app-subnet-2` | `us-east-1b` | Private App | `10.0.12.0/24` | 251 | NAT Gateway |
| `private-db-subnet-1` | `us-east-1a` | Private DB | `10.0.21.0/24` | 251 | None (Isolated) |
| `private-db-subnet-2` | `us-east-1b` | Private DB | `10.0.22.0/24` | 251 | None (Isolated) |
