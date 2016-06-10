/*
    VPC with Public subnet only
*/

variable "proj_prefix" {}
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "aws_default_az" {}


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
output "subnet_id" { value = "${module.public_subnet.subnet_id}" }
