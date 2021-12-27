resource "aws_launch_configuration" "launch" {
    name = "launch"
    image_id =  "ami-0d527b8c289b4af7f"
    security_groups = [aws_security_group.asg.id]
    instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "autoscaling" { 
  depends_on                = [aws_launch_configuration.launch]
  name                      = "auto-scale-group-test"
  max_size                  = 1
  min_size                  = 1
  launch_configuration      = aws_launch_configuration.launch.name
  vpc_zone_identifier       = [element(aws_subnet.public[*].id, var.az_count)] 

  tag {
    key                 = "Name"
    value               = "${var.app_name}-VPC-bastion"
    propagate_at_launch = true
  }
}