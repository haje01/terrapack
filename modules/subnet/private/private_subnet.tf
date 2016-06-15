/*
    Private subnet
*/

variable "proj_prefix" {}
variable "proj_desc" {}
variable "proj_owner" {}

variable "aws_key_name" {}
variable "aws_vpc_id" {}
variable "aws_region" {}
variable "aws_availability_zones" {}
variable "bastion_instance_type" {}

variable "subnet_cidrs" { default = "10.0.5.0/24,10.0.6.0/24,10.0.7.0/24" }
variable "vpc_cidr" {}
variable "developer_cidr" {}
variable "public_subnet_ids" {}
variable "count" { default = 1 }


resource "aws_subnet" "private" {
    vpc_id = "${var.aws_vpc_id}"
    count = "${var.count}"
    
    cidr_block = "${element(split(",", var.subnet_cidrs), count.index)}"
    availability_zone = "${element(split(",", var.aws_availability_zones), count.index)}"
        
    tags {
        Name = "${var.proj_prefix}-private${count.index + 1}"
    }
}       
output "subnet_ids" { value = "${join(",", aws_subnet.private.*.id)}" }
output "subnet_cidrs" { value = "${var.subnet_cidrs}" }
        
        
resource "aws_route_table" "private" {
    vpc_id = "${var.aws_vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${module.bastion.instance_id}"
    }   
        
    tags {
        Name = "${var.proj_prefix}-private"
    }   
}       

    
resource "aws_route_table_association" "private" {
    count = "${var.count}"
    subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
    route_table_id = "${aws_route_table.private.id}"
}   


module "bastion" {
    source = "../../../modules/bastion"
    proj_prefix = "${var.proj_prefix}"
    proj_desc = "${var.proj_desc}"
    proj_owner = "${var.proj_owner}"
    aws_key_name = "${var.aws_key_name}"
    aws_availability_zones = "${var.aws_availability_zones}"
    aws_vpc_id = "${var.aws_vpc_id}"
    aws_region = "${var.aws_region}"
    instance_type = "${var.bastion_instance_type}"
    vpc_cidr = "${var.vpc_cidr}"
    developer_cidr = "${var.developer_cidr}"
    public_subnet_ids = "${var.public_subnet_ids}"
    count = "${var.count}"
}
output "bastion_security_group" { value = "${module.bastion.security_group}" }
