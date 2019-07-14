provider "aws" {}

terraform {
    backend "s3" {
        bucket = "terraform-batch38"
        key    = "mediawiki/terraform.tfstate"
        region = "us-east-1"
  }
}


module "VPC" {
    source                  =   "./modules/vpc"
    PROJECT_NAME            =   "${var.PROJECT_NAME}"
    VPC_CIDR                =   "${var.VPC_CIDR}"
}       

module "RDS" {      
    source                  =   "./modules/rds"
    PROJECT_NAME            =   "${var.PROJECT_NAME}"
    VPC_CIDR                =   "${var.VPC_CIDR}"
    VPC_ID                  =   "${module.VPC.VPC_ID}"
    PUBLIC_SUBNETS          =   "${module.VPC.PUBLIC_SUBNETS}"
    PRIVATE_SUBNETS         =   "${module.VPC.PRIVATE_SUBNETS}"
    DBUSER                  =   "${var.DBUSER}"
    DBPASS                  =   "${var.DBPASS}"
}