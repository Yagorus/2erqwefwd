resource "aws_instance" "name" {
  count         = var.az_count
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public[*].id
  tags = {
    Name = "${var.app_name}-ec2"
  }
}