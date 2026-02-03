# ECS service running stateless inference workload
# Designed for horizontal scaling behind ALB

resource "aws_ecs_service" "this" {
  name            = "${var.name}-service"
  cluster         = var.cluster_arn
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count

  launch_type = "EC2"
}
