/*
    VPC with Public subnet only
*/

variable "project" {}
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "aws_default_az" {}


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
