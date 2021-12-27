resource "aws_launch_configuration" "launch" {
    name = "launch"
    image_id = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["self"]
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

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
  vpc_zone_identifier       = [aws_subnet.public[0].id, aws_subnet.public[1].id] 

  tag {
    key                 = "Name"
    value               = "${var.app_name}-VPC-autoscaling-group"
    propagate_at_launch = true
  }
  
}