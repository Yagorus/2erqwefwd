data "aws_availability_zones" "available" {

}
/*
 data "aws_ami" "linux" {
     owners = ["amazon"]
     most_recent = true
     filter {
       name = "name"
       values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
     }
 }
 */