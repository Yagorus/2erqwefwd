variable "aws_region" {
  description = "aws region"
  default = "eu-central-1"
}
variable "aws_profile_access_key_path" {
  description = "aws access key"
  default = "/home/yegor/.aws/credentials"
}
variable "aws_profile" {
  description = "aws profile"
  default = "default"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}
variable "app_name" {
    description = "Name of project"
    type = string
    default = "web"
}
variable "environment" {
  type = string
  default = "VPC"
}
variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}
