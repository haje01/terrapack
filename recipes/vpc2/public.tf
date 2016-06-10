/*
    Public Servers
*/
resource "aws_security_group" "web" {
    name = "${var.project}-web"
    description = "Allow incoming HTTP connections"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
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
        Name = "${var.project}-web"
    }
}


resource "aws_instance" "web" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "${var.aws_default_az}"
    instance_type = "${var.default_instance}"
    key_name = "${var.aws_key_name}"
    security_groups = ["${aws_security_group.web.id}"]
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    
    tags {
        Name = "${var.project}-web"
        Project = "${var.project}"
    }
}


resource "aws_eip" "web" {
    instance = "${aws_instance.web.id}"
    vpc = true
}
