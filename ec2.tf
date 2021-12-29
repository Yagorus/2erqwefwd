/*
resource "aws_instance" "name" {
    depends_on  = [aws_security_group.ec2, aws_subnet.public]
    count         = var.az_count
    subnet_id =  element(aws_subnet.public.*.id, count.index)

    ami = "ami-0d527b8c289b4af7f"
    instance_type = "t2.micro"
    key_name = "VPC_key_rsa"

    security_groups = [aws_security_group.ec2.id]
    
    user_data = file("user_data.sh")

    tags = {
        Name = "${var.app_name}-ec2"
    }
}
*/