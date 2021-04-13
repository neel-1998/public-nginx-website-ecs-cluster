resource "aws_autoscaling_group" "nginx_web_ecs_asg" {
  name                 = "nginx-web-ecs-asg"
  vpc_zone_identifier  = aws_subnet.public_subnet.*.id
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  force_delete         = true

  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"
  protect_from_scale_in     = true
  lifecycle {
    create_before_destroy = true
  }
}
