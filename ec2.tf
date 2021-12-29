resource "aws_instance" "name" {
    depends_on  = [aws_security_group.asg, aws_subnet.public]
    count         = var.az_count
    subnet_id =  element(aws_subnet.public.*.id, count.index)

    ami = "ami-05d34d340fb1d89e5"
    instance_type = "t2.micro"

    security_groups = [aws_security_group.asg.id]
    
    user_data = file("user_data.sh")

    tags = {
        Name = "${var.app_name}-ec2"
    }
}