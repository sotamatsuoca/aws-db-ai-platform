resource "aws_db_instance" "this" {
  identifier        = var.name
  engine            = "postgres"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = var.username
  password = var.password

  multi_az = true
  backup_retention_period = 7

  skip_final_snapshot = true
}
