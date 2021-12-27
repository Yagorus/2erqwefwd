data "aws_availability_zones" "available" {

}
data "aws_ami" "ubuntu20" {
    most_recent = true
    owners = ["753214776066"]
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-20.04-amd64-server-*"]
    }

}