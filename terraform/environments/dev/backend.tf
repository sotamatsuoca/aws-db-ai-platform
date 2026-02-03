# Example remote backend (S3 + DynamoDB)
# Uncomment and configure the values when ready.
# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-bucket"
#     key            = "envs/dev/terraform.tfstate"
#     region         = "ap-northeast-1"
#     dynamodb_table = "terraform-locks"
#   }
# }

# For now, using local backend as placeholder.
terraform {
  backend "local" {}
}
