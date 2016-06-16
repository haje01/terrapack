variable proj_prefix {}
variable proj_desc {}
variable proj_owner {}

variable user_cidr { default = "0.0.0.0/0" }
variable developer_cidr {}
variable vpc_id {}


resource "aws_security_group" "web" {
    name = "${var.proj_prefix}-web"
    description = "Allow incoming HTTP connections"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.user_cidr}"]
    }

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
        cidr_blocks = ["${var.user_cidr}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${var.vpc_id}"

    tags {
        Name = "${var.proj_prefix}-web"
        Desc = "${var.proj_desc}"
        Owner = "${var.proj_owner}"
    }
}
output "id" { value = "${aws_security_group.web.id}" }
