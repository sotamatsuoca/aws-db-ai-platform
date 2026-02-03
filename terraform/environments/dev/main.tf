provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../modules/vpc"
  name   = "dev-vpc"
  cidr   = "10.0.0.0/16"
  azs    = ["ap-northeast-3a", "ap-northeast-3c"]
}

module "iam" {
  source = "../../modules/iam"
  name   = "dev"
}
