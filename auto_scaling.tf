resource "aws_launch_configuration" "launch" {
    name = "launch"
    image_id = data.aws_ami.ubuntu20.id
    instance_type = "t2.micro"
}


resource "aws_autoscaling_group" "autoscaling" { 
  depends_on                = [aws_launch_configuration.launch]
  count                     = var.az_count
  name                      = "autoscaling"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.launch.name
  vpc_zone_identifier       = element(aws_subnet.public.*.id, count.index)

  tag {
    key                 = "Name"
    value               = "${var.app_name}-VPC-autoscaling-group"
    propagate_at_launch = true
  }
  
}