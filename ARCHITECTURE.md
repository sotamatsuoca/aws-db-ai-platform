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