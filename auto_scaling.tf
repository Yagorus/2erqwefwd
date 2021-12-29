resource "aws_launch_configuration" "launch" {
    depends_on  = [aws_security_group.asg]
    name = "launch"
    image_id = "ami-0d527b8c289b4af7f"
    security_groups = [aws_security_group.asg.id]
    instance_type = "t2.micro"
    user_data = file("user_data.sh")
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "app" { 
  depends_on                = [aws_launch_configuration.launch]
  name                      = "auto-asg"
  desired_capacity          = 2
  max_size                  = 2
  min_size                  = 2
  health_check_type         = "EC2"
  launch_configuration      = aws_launch_configuration.launch.name
  vpc_zone_identifier       = [for subnet in aws_subnet.public : subnet.id]
  load_balancers            = [aws_alb.main.id]
  target_group_arns         = [aws_alb_target_group.app.arn]

  tag {
    key                 = "Name"
    value               = "${var.app_name}-ec2"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_attachment" "name" {
  autoscaling_group_name = aws_autoscaling_attachment.app.id
  alb_target_group_arn = aws_alb_target_group.app.arn
}

