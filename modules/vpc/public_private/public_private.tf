/*
    VPC with Public & Private subnets
*/

variable "proj_prefix" {}

variable "aws_key_name" {}
variable "aws_default_az" {}
variable "bastion_instance_type" {}

variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "developer_cidr" {}


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
    aws_default_az = "${var.aws_default_az}"
}


module "private_subnet" {
    source = "../../../modules/subnet/private/"
    proj_prefix = "${var.proj_prefix}"

    aws_key_name = "${aws_key_name}"
    aws_vpc_id = "${aws_vpc.default.id}"
    aws_default_az = "${var.aws_default_az}"
    bastion_instance_type = "${var.bastion_instance_type}"

    vpc_cidr = "${var.vpc_cidr}"
    developer_cidr = "${var.developer_cidr}"
    public_subnet_id = "${module.public_subnet.subnet_ids}"
}
