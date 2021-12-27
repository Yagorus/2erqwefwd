
provider "aws" {
    region      = var.aws_region
    profile     = var.aws_profile
    shared_credentials_file = var.aws_profile_access_key_path
}
