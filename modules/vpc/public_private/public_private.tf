/*
    VPC with Public & Private subnets
*/

variable "proj_prefix" {}
variable "proj_desc" {}
variable "proj_owner" {}

variable "aws_key_name" {}
variable "aws_region" {}
variable "aws_availability_zones" {}
variable "bastion_instance_type" {}

variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "developer_cidr" {}
variable "public_subnet_count" { default = 1 }
variable "private_subnet_count" { default = 1 }


resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "${var.proj_prefix}"
    }   
}   
output "vpc_id" { value = "${aws_vpc.default.id}" }


module "public_subnet" {
    source = "../../../modules/subnet/public/"
    proj_prefix = "${var.proj_prefix}"
    aws_vpc_id = "${aws_vpc.default.id}"
    aws_availability_zones = "${var.aws_availability_zones}"
    count = "${var.public_subnet_count}"
}
output "public_subnet_ids" { value = "${module.public_subnet.subnet_ids}" }


module "private_subnet" {
    source = "../../../modules/subnet/private/"
    proj_prefix = "${var.proj_prefix}"
    proj_desc = "${var.proj_desc}"
    proj_owner = "${var.proj_owner}"
    aws_key_name = "${var.aws_key_name}"
    aws_region = "${var.aws_region}"
    aws_vpc_id = "${aws_vpc.default.id}"
    aws_availability_zones = "${var.aws_availability_zones}"
    bastion_instance_type = "${var.bastion_instance_type}"
    vpc_cidr = "${var.vpc_cidr}"
    developer_cidr = "${var.developer_cidr}"
    public_subnet_ids = "${module.public_subnet.subnet_ids}"
}
output "private_subnet_cidrs" { value = "${module.private_subnet.subnet_cidrs}" }
output "bastion_security_group" { value = "${module.private_subnet.bastion_security_group}" }
