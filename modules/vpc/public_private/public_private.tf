/*
    VPC with Public & Private subnets
*/

variable "project" {}

variable "aws_key_name" {}
variable "aws_default_az" {}
variable "aws_default_instance" {}

variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "developer_cidr" {}


resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "${var.project}-default"
        Project = "${var.project}"
    }   
}   


module "public_subnet" {
    source = "../../../modules/subnet/public/"
    project = "${var.project}"
    aws_vpc_id = "${aws_vpc.default.id}"
    aws_default_az = "${var.aws_default_az}"
}


module "private_subnet" {
    source = "../../../modules/subnet/private/"
    project = "${var.project}"

    aws_key_name = "${aws_key_name}"
    aws_vpc_id = "${aws_vpc.default.id}"
    aws_default_az = "${var.aws_default_az}"
    aws_default_instance = "${var.aws_default_instance}"

    vpc_cidr = "${var.vpc_cidr}"
    developer_cidr = "${var.developer_cidr}"
    public_subnet_id = "${module.public_subnet.public_subnet_id}"
}
