data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon", "self"]
}

resource "aws_launch_configuration" "ecs_launch_config" {
  image_id                    = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
  security_groups = [aws_security_group.ec2_sg.id]
  user_data       = <<EOF
#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
EOF
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "worker"
  container_definitions = file("./templates/task-definition.json")
  network_mode          = "bridge"
}

# Service without ASG incorporated
# resource "aws_ecs_service" "worker" {
#   name            = "web-service"
#   cluster         = aws_ecs_cluster.ecs_cluster.id
#   task_definition = aws_ecs_task_definition.task_definition.arn
#   desired_count   = 2
#   ordered_placement_strategy {
#     type  = "binpack"
#     field = "cpu"
#   }
#   load_balancer {
#     target_group_arn = aws_lb_target_group.lb_target_group.arn
#     container_name   = "nginx-web"
#     container_port   = 80
#   }
#   launch_type = "EC2"
#   depends_on  = [aws_lb_listener.web_listener]
# }

# Service with ASG incorporated

resource "aws_ecs_capacity_provider" "nginx_web_capacity_provider" {
  name = "nginx-web-capacity-provider"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.nginx_web_ecs_asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

resource "aws_ecs_service" "service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 2
  # Containers placed s.t. number of ec2 instances optimised based off ec2 instances
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "nginx-web"
    container_port   = 80
  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.web_listener]
}
