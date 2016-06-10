/*
    NGINX Sample
*/
variable proj_prefix {}
variable proj_desc {}

variable aws_key_name {}
variable aws_key_path {}
variable aws_default_az {}

variable user_cidr { default = "0.0.0.0/0" }
variable developer_cidr {}
variable instance_type {}
variable subnet_id {}
variable vpc_id {}
variable ami_id{}


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
        cidr_blocks = ["0.0.0.0/0"]
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
    }
}


resource "aws_instance" "web" {
    ami = "${var.ami_id}"
    availability_zone = "${var.aws_default_az}"
    instance_type = "${var.instance_type}"
    key_name = "${var.aws_key_name}"
    security_groups = ["${aws_security_group.web.id}"]
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "${var.proj_prefix}-web"
        Desc = "${var.proj_desc}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get -y update",
            "sudo apt-get -y install nginx",
            "sudo service nginx start"
        ]
        connection {
            user = "ubuntu"
            key_file = "${var.aws_key_path}"
        }
    }
}
