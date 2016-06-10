variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}


variable "project" {
    description = "Project Name"
}


variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "ap-northeast-2"  # Seoul
}


variable "aws_default_az" {
    description = "EC2 Default Availability zone"
    default = "ap-northeast-2a"  # Seoul
}


variable "aws_alter_az" {
    description = "EC2 Alternative Availability zone"
    default = "ap-northeast-2b"  # Seoul
}


variable "amis" {
    description = "AMIs by region"
    default = {
        ap-northeast-2 = "ami-09dc1267"  # Seoul/Ubuntu Server 14.04 LTS (HVM)
    }
}


variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}


variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}


variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}


variable "default_instance" {
    description = "Default Instance type"
    default = "t2.small"  # $0.04 per Hour
}


variable "developer_cidr" {
    description = "Internal Developer CIDR"
}
