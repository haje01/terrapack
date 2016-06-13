/*
    SimpleWep recipe
*/

variable "proj_prefix" {}
variable "proj_desc" {}
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


module "web" {
    source = "../../modules/sample/nginx"
    proj_prefix = "${var.proj_prefix}"
    proj_desc = "${var.proj_desc}"
    aws_default_az = "${var.aws_default_az}"
    aws_key_name = "${var.aws_key_name}"
    aws_key_path = "${var.aws_key_path}"
    ami_id = "${module.ubuntu_ami.id}"
    developer_cidr = "${var.developer_cidr}"
    instance_type = "${var.default_instance_type}"
    vpc_id = "${module.public_only_vpc.vpc_id}"
    subnet_id = "${module.public_only_vpc.subnet_id}"
}
