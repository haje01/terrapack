/*
    Nginx cluster sample recipe
*/

variable "proj_prefix" {}
variable "proj_desc" {}
variable "proj_owner" {}
variable "aws_key_path" {}
variable "aws_key_name" {}
variable "aws_region" {}
variable "aws_default_az" {}
variable "default_instance_type" {}
variable "developer_cidr" {}


provider "aws" {
    region = "${var.aws_region}"
}


module "public_only_vpc" {
    source = "../../modules/vpc/public_only"
    proj_prefix = "${var.proj_prefix}"
    aws_default_az = "${var.aws_default_az}"
}


module "ubuntu_ami" {
  source = "../../modules/ami/ubuntu"
  region = "${var.aws_region}"
}
