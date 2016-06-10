/*
    Bastion(NAT) Instance
*/

variable "proj_prefix" {}
variable "proj_desc" {}

variable "aws_key_name" {}
variable "aws_vpc_id" {}
variable "aws_region" {}
variable "aws_default_az" {}
variable "aws_bastion_ami" { 
    default="ami-0d32fa63"  # Seoul/Amazon Linux AMI 2016.03.1 x86_64 VPC NAT HVM EBS
}
variable "instance_type" {}

variable "vpc_cidr" {}
variable "developer_cidr" {}
variable "public_subnet_id" {}


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


module "bastion_ami" {
    source = "../../modules/ami/nat"
    region = "${aws_region}"
}


resource "aws_instance" "bastion" {
    ami = "${module.bastion_ami.id}"
    availability_zone = "${var.aws_default_az}"
    instance_type = "${var.instance_type}"
    key_name = "${var.aws_key_name}"
    security_groups = ["${aws_security_group.bastion.id}"]
    subnet_id = "${var.public_subnet_id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "${var.proj_prefix}-bastion"
        Desc = "${var.proj_desc}"
    }
}

output "instance_id" { value = "${aws_instance.bastion.id}" }


resource "aws_eip" "bastion" {
    instance = "${aws_instance.bastion.id}"
    vpc = true
}
