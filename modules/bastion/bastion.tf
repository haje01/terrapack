/*
    Bastion(NAT) Instance
*/

variable "proj_prefix" {}
variable "proj_desc" {}
variable "proj_owner" {}

variable "aws_key_name" {}
variable "aws_vpc_id" {}
variable "aws_region" {}
variable "aws_availability_zones" {}
variable "instance_type" {}

variable "vpc_cidr" {}
variable "developer_cidr" {}
variable "public_subnet_ids" {}
variable "count" {}


resource "aws_security_group" "bastion" {
    name = "${var.proj_prefix}-bastion"
    description = "Allow traffic to pass from the private subnet to the internet"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.developer_cidr}"]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${var.aws_vpc_id}"

    tags {
        Name = "${var.proj_prefix}-bastion"
    }
}
output "security_group" { value = "${aws_security_group.bastion.id}" }


module "bastion_ami" {
    source = "../../modules/ami/nat"
    region = "${var.aws_region}"
}


resource "aws_instance" "bastion" {
    count = "${var.count}"
    ami = "${module.bastion_ami.id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
    subnet_id = "${element(split(",", var.public_subnet_ids), count.index)}"
    availability_zone = "${element(split(",", var.aws_availability_zones), count.index)}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "${var.proj_prefix}-bastion${count.index + 1}"
        Desc = "${var.proj_desc}"
        Owner = "${var.proj_owner}"
    }
}
output "instance_id" { value = "${aws_instance.bastion.id}" }


resource "aws_eip" "bastion" {
    instance = "${aws_instance.bastion.id}"
    vpc = true
}
