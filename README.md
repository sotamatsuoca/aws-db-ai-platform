- STATUS CHECK
 - Amazon Leadership Principles (CV + LinkedIn + Applications)
 - Python / Shell automation scripts
 - Uploaded .py to GitHub
 - Production ops / incident response exp
 - Resume + LinkedIn groundwork

- Technical Depth
 - Goal: BigTech-ready DevOps Engineer

## PHASE 1 — Core Cloud
- Cloud Platforms
 - VPC + subnets
 - Compute + Load Balancer
 - IAM (roles, least privilege)
- Output
 - `cloud-basics/` repo
 - Architecture diagram (README)

- GitHub Hygiene
 - Clean profile
 - Proper READMEs
 - Commit messages
 - Pin 2–3 repos
  - “Understands cloud architecture, not just services”

- Terraform
 - Providers
 - Modules
 - Remote state
 - Environments (dev/stage/prod)
 **Deliverable**
  - `terraform-aws-vpc/`
  - `terraform-aws-ecs-or-eks/`
   - Terraform
   - IaC
   - Reusable modules

## PHASE 2 — CI/CD + Containers
- GitHub Actions
 - Build → Test → Deploy
 - Secrets handling
 - Terraform plan/apply in pipeline
 **Deliverable**
  - `.github/workflows/ci.yml`
  - Auto-deploy infra or app

### Containers & Kubernetes (CRITICAL)
- Docker
 - Multi-stage builds
 - Image optimization

- Kubernetes
 - EKS or GKE
 - Deployments, Services
 - ConfigMaps, Secrets
 - Helm basics
 **Deliverable**
  - `k8s-microservice-demo/`
  - `helm-chart/`

## PHASE 3 — SRE + Automation + Security
- Configuration & Automation
 - Ansible basics
 - Infra + app config
 - Bash + Python glue code

- SRE & Observability
 - Prometheus
 - Grafana
 - Logging
 - Alerts
 - SLIs / SLOs
 **Deliverable**
  - Monitoring dashboard screenshots
  - Incident simulation write-up

### DevSecOps + Networking
- DevSecOps
 - Secrets management
 - IAM policies
 - Container scanning
 - Policy as code (intro)
- Networking
 - DNS
 - Load balancing
 - TCP basics
 - VPC peering

## PHASE 4 — Interview-Grade Polish
- Source Control & Collaboration
 - Advanced Git
 - PR workflows
 - Trunk-based dev
 - Code review mindset

- System Design
 - Design CI/CD system
 - Design scalable infra
 - Failure scenarios
 - Cost tradeoffs

- Finalization & Applications
 - Resume final pass
 - STAR stories (Leadership + incidents)
 - Mock interviews
 - Start active applications
 - Active applications

---

## FINAL PORTFOLIO CHECKLIST
- Terraform infrastructure repo
- GitHub Actions CI/CD pipeline
- Kubernetes deployment
- Monitoring & alerting setup
- Python automation
- Clear READMEs & architecture diagrams


| Task                  | `git` | `gh`                  |
| --------------------- | ----- | --------------------- |
| Local version control | Y     | Y' (delegates to git) |
| Create commits        | Y     | N                     |
| Branching             | Y     | N                     |
| Push / pull           | Y     | Y'                    |
| Create GitHub repo    | N     | Y                     |
| PRs / issues          | N     | Y                     |
| Auth handling         | N     | Y                     |
| Repo cloning          | Y'    | Y                     |


# AWS DB AI Platform

A production-ready Terraform infrastructure-as-code (IaC) repository for deploying a scalable, AI-enabled platform on AWS.

## Project Overview

This repository contains modular Terraform configurations to deploy:
- **VPC**: Isolated network with public/private subnets (planned)
- **ECS**: Container orchestration for microservices
- **RDS PostgreSQL**: Multi-AZ relational database with automated backups
- **IAM**: Least-privilege role-based access control
- **CloudWatch**: Monitoring and alerting
- **ALB**: Application Load Balancer for routing (planned)

**Stack:** Terraform 1.5.0+ | AWS Provider 5.0+

---

## Architecture

```
                        ┌─────────────┐
                        │  CloudWatch │
                        │  (Metrics)  │
                        └──────▲──────┘
                               │
           ┌───────────────────┼────────────────────┐
           │                   │                    │
      ┌────────────┐   ┌───────────────┐   ┌──────────────┐
      │    ECS     │   │     ALB       │   │     RDS      │
      │  Cluster   │   │  (in VPC)     │   │  PostgreSQL  │
      │  + Tasks   │   │   (planned)   │   │  (Multi-AZ)  │
      └────────────┘   └───────────────┘   └──────────────┘
           │                   │                    │
           └───────────────────┼────────────────────┘
                               │
                        ┌──────┴──────┐
                        │     VPC     │
                        │  10.0.0.0/16│
                        │  (planned)  │
                        └─────────────┘
```

---

## Project Structure

```
terraform/
├── versions.tf                          # Global Terraform & provider config
│
├── modules/                             # Reusable infrastructure components
│   ├── vpc/
│   │   ├── main.tf                      # VPC core resources
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── iam/
│   │   ├── ecs.tf                       # ECS task/execution roles
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ecs/
│   │   ├── cluster.tf
│   │   ├── service.tf
│   │   ├── taskdef.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── rds/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── monitoring/
│       ├── cloudwatch.tf
│       └── variables.tf
│
└── environments/
    ├── dev/                             # Development environment
    │   ├── backend.tf                   # State backend config (S3 ready)
    │   ├── main.tf                      # Module wiring
    │   ├── variables.tf
    │   └── terraform.tfvars
    └── prod/                            # Production environment (skeleton)
        └── ...

.gitignore                               # Terraform build artifacts
```

---

## Quick Start

### Prerequisites

1. **Terraform** ≥ 1.5.0
   ```bash
   terraform version
   ```

2. **AWS CLI** configured (after account setup)
   ```bash
   aws configure
   ```

3. **Git** for version control

### Phase 1: Validate Terraform

No AWS account needed yet. Verify syntax and structure:

```bash
cd terraform/environments/dev

# Initialize Terraform (local backend)
terraform init

# Check syntax
terraform validate

# Preview what would be created (will fail without AWS creds)
terraform plan
```

**Expected outcome:** File structure is valid, no AWS calls made.

---

## Phase 2: Prepare for Deployment (Before AWS)

### Phase 2A: Infrastructure Code ✅ DONE
- Modular VPC, IAM, ECS, RDS, CloudWatch modules
- Pinned versions (Terraform 1.5.0+, AWS ~5.0)
- S3 backend config ready (commented)

### Phase 2B: Expand Infrastructure (TODO)
- [ ] **VPC**: Add public/private subnets, NAT gateway
- [ ] **ALB**: Add load balancer + security groups
- [ ] **IAM**: Harden policies (least-privilege)
- [ ] **RDS**: Add subnet groups + parameter groups

### Phase 2C: Documentation (In Progress)
- [ ] Deployment checklist
- [ ] Variable defaults & overrides
- [ ] Monitoring setup instructions

---

## Phase 3: AWS Account Setup & Deployment

### Prerequisites
- [ ] AWS account created
- [ ] MFA enabled on root account
- [ ] Budget alert set ($X/month soft limit)
- [ ] Dev IAM user created (with programmatic access)

### Deployment Steps

1. **Enable S3 Backend** (optional but recommended)
   ```bash
   # After S3 bucket & DynamoDB table created:
   cd terraform/environments/dev
   
   # Uncomment backend "s3" block in backend.tf
   terraform init -reconfigure
   ```

2. **Configure Variables**
   ```bash
   # Edit terraform.tfvars with your AWS region, DB password, etc.
   nano terraform.tfvars
   ```

3. **Plan & Apply**
   ```bash
   terraform plan -out=tfplan
   terraform apply tfplan
   ```

4. **Verify Deployment**
   ```bash
   aws ecs list-clusters
   aws rds describe-db-instances
   aws cloudwatch describe-alarms
   ```

5. **Test & Monitor**
   - Visit ALB DNS name in browser
   - Check CloudWatch metrics
   - Verify RDS connectivity

### Destroy (Cleanup)

When done testing:

```bash
cd terraform/environments/dev

# Verify what will be destroyed
terraform plan -destroy

# Destroy all resources
terraform destroy

# Confirm all resources gone in AWS Console
```

**Important:** Destroying removes databases, ECS tasks, and load balancers. Ensure backups are taken if needed.

---

## Why This Architecture?

| Choice | Reason |
|--------|--------|
| **Modular design** | Reusable across environments (dev/prod) |
| **ECS over EKS** | Simpler for small teams, lower operational overhead |
| **Multi-AZ RDS** | High availability, automatic failover |
| **IAM roles** | Least-privilege, secure service-to-service auth |
| **CloudWatch** | Built-in AWS observability, no extra costs |
| **S3 backend** | Shared state, DynamoDB locking prevents conflicts |

---

## Module Reference

### VPC Module
```hcl
module "vpc" {
  source = "../../modules/vpc"
  name   = "dev-vpc"
  cidr   = "10.0.0.0/16"
  azs    = ["ap-northeast-3a", "ap-northeast-3c"]
}
```

### IAM Module
```hcl
module "iam" {
  source = "../../modules/iam"
  name   = "dev"
}
```

### ECS Module
```hcl
module "ecs" {
  source            = "../../modules/ecs"
  name              = "dev-app"
  image             = "123456789.dkr.ecr.ap-northeast-3.amazonaws.com/my-app:latest"
  execution_role_arn = module.iam.ecs_task_role_arn
  task_role_arn     = module.iam.ecs_task_role_arn
  cluster_arn       = module.vpc.vpc_id  # Will wire properly in Phase 2B
  desired_count     = 1
}
```

### RDS Module
```hcl
module "rds" {
  source   = "../../modules/rds"
  name     = "dev-db"
  username = "postgres"
  password = var.db_password  # Use Terraform variables, never hardcode
}
```

---

## Common Tasks

### Change environment variable
```bash
cd terraform/environments/dev
nano terraform.tfvars
terraform plan
terraform apply
```

### Add a new AWS resource
1. Create `.tf` file in appropriate module
2. Add to `variables.tf` if needed
3. Add to `outputs.tf` if other modules depend on it
4. Wire in `environments/dev/main.tf`

### Validate without AWS credentials
```bash
terraform validate
terraform fmt -check .
```

### Generate documentation
```bash
# Install terraform-docs
terraform-docs markdown . > docs/terraform.md
```

---

## Security Best Practices

1. **Never commit secrets:**
   - Use `.gitignore` for `.tfstate`, `.terraform/`
   - Store passwords in AWS Secrets Manager
   - Use `terraform.tfvars.example` for template

2. **Least-privilege IAM:**
   - Each service assumes a specific role
   - Policies grant only required permissions

3. **State backend:**
   - Enable S3 versioning
   - Enable DynamoDB locking
   - Enable KMS encryption

4. **Networking:**
   - RDS in private subnet (no public access)
   - ALB in public subnet
   - Security groups restrict traffic

---

## Learning Resources

| Topic | Resource |
|-------|----------|
| Terraform | [hashicorp.com/terraform/docs](https://www.terraform.io/docs) |
| AWS | [docs.aws.amazon.com](https://docs.aws.amazon.com) |
| ECS Best Practices | [AWS ECS Guide](https://docs.aws.amazon.com/ecs/) |
| Terraform State | [State Management](https://www.terraform.io/language/state) |

---

## Roadmap

- [ ] **Phase 2B**: Subnets, NAT, ALB, SGs
- [ ] **Phase 2C**: Secrets Manager, parameter groups
- [ ] **Phase 3**: AWS account + first deploy
- [ ] **Phase 4**: CI/CD pipeline (GitHub Actions → ECR → ECS)
- [ ] **Phase 5**: Auto-scaling groups + Spot instances
- [ ] **Phase 6**: Multi-region failover

---

## Interview Talking Points

1. **Modularity:** Why each resource is in its own module
2. **State management:** Why S3 + DynamoDB is better than local state
3. **IAM design:** Least-privilege across services
4. **Cost optimization:** t3.micro RDS, spot instances, data transfer zones
5. **Disaster recovery:** Multi-AZ, backups, destroy/recreate workflow

---

## Contributing

1. Validate syntax: `terraform validate`
2. Format code: `terraform fmt -recursive .`
3. Plan before apply: `terraform plan -out=tfplan`
4. Use meaningful commit messages

---

## License

[e.g., MIT, Apache 2.0]

---

## Author

[S. M. / DevOps]

---

**Last Updated:** February 2026  
**Status:** Phase 2A | Phase 2B | Phase 3