data "aws_availability_zones" "available" {

}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["753214776066"]

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}
data "aws_ami_ids" "ubuntu" {
  owners = ["753214776066"]

  filter {
    name   = "name"
    values = ["ubuntu/images/ubuntu-*-*-amd64-server-*"]
  }
}

