provider "aws" {}

terraform {
    backend "s3" {
        bucket = "terraform-july-2019-100"
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

module "EC2" {      
    source                  =   "./modules/ec2"
    PROJECT_NAME            =   "${var.PROJECT_NAME}"
    VPC_CIDR                =   "${var.VPC_CIDR}"
    VPC_ID                  =   "${module.VPC.VPC_ID}"
    PUBLIC_SUBNETS          =   "${module.VPC.PUBLIC_SUBNETS}"
    PRIVATE_SUBNETS         =   "${module.VPC.PRIVATE_SUBNETS}"
    DBUSER                  =   "${var.DBUSER}"
    DBPASS                  =   "${var.DBPASS}"
    DBHOST                  =   "${module.RDS.rds-endpoint}"
}

output "pem_content" {
    value = "${module.EC2.pem_content}"
}
