/*
    Private subnet
*/

variable "project" {}

variable "aws_key_name" {}
variable "aws_vpc_id" {}
variable "aws_default_az" {}
variable "aws_default_instance" {}

variable "private_subnet_cidr" { default = "10.0.1.0/24" }
variable "vpc_cidr" {}
variable "developer_cidr" {}
variable "public_subnet_id" {}


resource "aws_subnet" "private" {
    vpc_id = "${var.aws_vpc_id}"
    
    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "${var.aws_default_az}"
        
    tags {
        Name = "${var.project}-private"
        Project = "${var.project}"
    }
}       
        
        
resource "aws_route_table" "private" {
    vpc_id = "${var.aws_vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${var.bastion_id}"
        instance_id = "${module.bastion.instance_id}"
    }   
        
    tags {
        Name = "${var.project}-private"
    }   
}       

    
resource "aws_route_table_association" "private" {
    subnet_id = "${var.private_subnet_cidr}"
    route_table_id = "${aws_route_table.private.id}"
}   


module "bastion" {
    source = "../../../modules/bastion"
    project = "${var.project}"

    aws_key_name = "${var.aws_key_name}"
    aws_default_az = "${var.aws_default_az}"
    aws_default_instance = "${var.aws_default_instance}"
    aws_vpc_id = "${var.aws_vpc_id}"

    vpc_cidr = "${var.vpc_cidr}"
    developer_cidr = "${var.developer_cidr}"
    public_subnet_id = "${var.public_subnet_id}"
}
