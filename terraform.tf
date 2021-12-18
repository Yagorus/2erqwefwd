
provider "aws" {
    region      = var.aws_region
    #profile     = var.aws_profile
    access_key  = var.aws_profile_access_key
    secret_key  = var.aws_profile_secret_key
}
