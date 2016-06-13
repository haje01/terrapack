/*
    Private subnet
*/

variable "proj_prefix" {}
variable "proj_desc" {}
variable "proj_owner" {}

variable "aws_key_name" {}
variable "aws_vpc_id" {}
variable "aws_default_az" {}
variable "bastion_instance_type" {}

variable "private_subnet_cidr" { default = "10.0.1.0/24" }
variable "vpc_cidr" {}
variable "developer_cidr" {}
variable "public_subnet_id" {}


resource "aws_subnet" "private" {
    vpc_id = "${var.aws_vpc_id}"
    
    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "${var.aws_default_az}"
        
    tags {
        Name = "${var.proj_prefix}-private"
    }
}       
output "subnet_id" { value = "${aws_subnet.private.id}" }
        
        
resource "aws_route_table" "private" {
    vpc_id = "${var.aws_vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${var.bastion_id}"
        instance_id = "${module.bastion.instance_id}"
    }   
        
    tags {
        Name = "${var.proj_prefix}-private"
    }   
}       

    
resource "aws_route_table_association" "private" {
    subnet_id = "${var.private_subnet_cidr}"
    route_table_id = "${aws_route_table.private.id}"
}   


module "bastion" {
    source = "../../../modules/bastion"
    proj_prefix = "${var.proj_prefix}"
    proj_desc = "${var.proj_desc}"
    proj_owner = "${var.proj_owner}"

    aws_key_name = "${var.aws_key_name}"
    aws_default_az = "${var.aws_default_az}"
    aws_vpc_id = "${var.aws_vpc_id}"
    instance_type = "${var.bastion_instance_type}"

    vpc_cidr = "${var.vpc_cidr}"
    developer_cidr = "${var.developer_cidr}"
    public_subnet_id = "${var.public_subnet_id}"
}
