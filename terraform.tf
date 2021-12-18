
provider "aws" {
    region      = var.aws_region
    profile     = "terraform-user"
    shared_credentials_file = "/home/yegor/.aws/credentials"

    #access_key  = var.aws_profile_access_key
    #secret_key  = var.aws_profile_secret_key
}
