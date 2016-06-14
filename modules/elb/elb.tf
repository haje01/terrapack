/*
    AWS ELB module
*/

variable proj_prefix {}
variable proj_desc {}
variable proj_owner {}

variable vpc_id {}
variable subnet_ids {}
variable instances {}


resource "aws_security_group" "elb" {
    name = "${var.proj_prefix}-elb"
    vpc_id = "${var.vpc_id}"
    
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.proj_prefix}-elb"
        Desc = "${var.proj_desc}"
        Owner = "${var.proj_owner}"
    }
}


resource "aws_elb" "elb" {
    name = "${var.proj_prefix}-elb"
    subnets = ["${var.subnet_ids}"]
    security_groups = ["${aws_security_group.elb.id}"]
    cross_zone_load_balancing = true

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    instances = ["${split(",", var.instances)}"]
}
