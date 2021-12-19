
provider "aws" {
    region      = data.aws_availability_zones.available.names[count.index]
    profile     = var.aws_profile
    shared_credentials_file = var.aws_profile_access_key_path
}
