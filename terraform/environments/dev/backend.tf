# Remote backend configuration (S3 + DynamoDB for state locking)
# Uncomment and initialize after AWS account setup:
#   terraform init -reconfigure
#
# terraform {
#   backend "s3" {
#     bucket         = "example-tf-state"
#     key            = "aws-db-ai-platform/dev.tfstate"
#     region         = "ap-northeast-1"
#     dynamodb_table = "terraform-locks"
#   }
# }

# Local backend for now (development)
terraform {
  backend "local" {}
}
