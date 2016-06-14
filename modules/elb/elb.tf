/*
    AWS ELB module
*/

variable proj_prefix {}
variable proj_desc {}
variable proj_owner {}

variable vpc_id {}
variable subnet_ids {}
variable instances {}
variable user_cidr {}
variable from_port {}
variable to_port {}


resource "aws_security_group" "elb" {
    name = "${var.proj_prefix}-elb"
    vpc_id = "${var.vpc_id}"
    
    ingress {
        from_port = "${var.from_port}"
        to_port = "${var.to_port}"
        protocol = "tcp"
        cidr_blocks = ["${var.user_cidr}"]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["${var.user_cidr}"]
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
        instance_port = "${var.from_port}"
        instance_protocol = "http"
        lb_port = "${var.to_port}"
        lb_protocol = "http"
    }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:${var.from_port}/"
        interval = 10
    }

    instances = ["${split(",", var.instances)}"]
}
