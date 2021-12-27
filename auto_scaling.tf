resource "aws_launch_configuration" "launch" {
    name = "launch"
    image_id =  "ami-0d527b8c289b4af7f"
    instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "autoscaling" { 
  depends_on                = [aws_launch_configuration.launch]
  count                     = var.az_count
  name                      = "autoscaling"
  max_size                  = 1
  min_size                  = 1
  launch_configuration      = aws_launch_configuration.launch.name
  vpc_zone_identifier       = [aws_subnet.public[count.index].id] 

  tag {
    key                 = "Name"
    value               = "${var.app_name}-VPC-autoscaling-group"
    propagate_at_launch = true
  }
}