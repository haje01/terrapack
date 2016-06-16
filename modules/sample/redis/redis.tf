/*
    Redis sample module
*/

variable proj_prefix {}
variable proj_desc {}
variable proj_owner {}

variable aws_key_name {}
variable aws_key_path {}
variable aws_availability_zones {}

variable app_security_group {}
variable bastion_security_group {}
variable instance_type {}
variable subnet_ids {}
variable vpc_id {}
variable redis_ami {}


resource "aws_security_group" "redis" {
    name = "${var.proj_prefix}-redis"
    description = "Allow incoming Redis request"

    ingress {
        from_port = 6379
        to_port = 6379
        protocol = "tcp"
        security_groups = ["${var.app_security_group}"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = ["${var.bastion_security_group}"]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        security_groups = ["${var.bastion_security_group}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = ["${var.app_security_group}"]
    }

    vpc_id = "${var.vpc_id}"

    tags {
        Name = "${var.proj_prefix}-redis"
        Desc = "${var.proj_desc}"
        Owner = "${var.proj_owner}"
    }
}


resource aws_instance "redis" {
    ami = "${var.redis_ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.redis.id}"]
    associate_public_ip_address = false
    source_dest_check = false

    subnet_id = "${element(split(",", var.subnet_ids), count.index)}"
    availability_zone = "${element(split(",", var.aws_availability_zones), count.index)}"

    tags {
        Name = "${var.proj_prefix}-redis${count.index + 1}"
        Desc = "${var.proj_desc}"
        Owner = "${var.proj_owner}"
    }
}
