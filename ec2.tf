/*
resource "aws_instance" "name" {
  count         = var.az_count
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"

  subnet_id =  element(aws_subnet.public.*.id, count.index)
  tags = {
    Name = "${var.app_name}-ec2"
  }
}
*/
resource "aws_instance" "name" {
    depends_on  = [aws_security_group.asg, aws_subnet.public]
    count         = var.az_count
    subnet_id =  element(aws_subnet.public.*.id, count.index)

    ami = "ami-0d527b8c289b4af7f"
    instance_type = "t2.micro"

    security_groups = [aws_security_group.asg.id]
    
    user_data = file("user_data.sh")

    tags = {
        Name = "${var.app_name}-ec2"
    }
}