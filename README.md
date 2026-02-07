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