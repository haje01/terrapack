/*
    Private Servers
*/
resource "aws_security_group" "redis" {
    name = "${var.project}-redis"
    description = "Allow incoming Redis connections"

    ingress {
        from_port = 6379
        to_port = 6379
        protocol = "tcp"
        security_groups = ["${aws_security_group.web.id}"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = ["${aws_security_group.bastion.id}"]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 6379
        to_port = 6379
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "${var.project}-redis"
    }
}


resource "aws_instance" "redis" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "${var.aws_default_az}"
    instance_type = "${var.default_instance}"
    key_name = "${var.aws_key_name}"
    security_groups = ["${aws_security_group.redis.id}"]
    subnet_id = "${aws_subnet.private.id}"
    source_dest_check = false
    
    tags {
        Name = "${var.project}-redis"
        Project = "${var.project}"
    }
}
