/*
    NGINX Sample
*/
variable proj_prefix {}
variable proj_desc {}
variable proj_owner {}

variable aws_key_name {}
variable aws_key_path {}
variable aws_availability_zones {}

variable user_cidr { default = "0.0.0.0/0" }
variable developer_cidr {}
variable instance_type {}
variable subnet_ids {}
variable vpc_id {}
variable ami_id {}
variable instance_count {}


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


module "elb" {
    source = "../../../modules/elb"
    proj_prefix = "${var.proj_prefix}"
    proj_desc = "${var.proj_desc}"
    proj_owner = "${var.proj_owner}"
    vpc_id = "${var.vpc_id}"
    subnet_ids = "${var.subnet_ids}"
    instances = "${join(",", aws_instance.web.*.id)}"
    user_cidr = "${var.user_cidr}"
    from_port = 80
    to_port = 80
}


resource "aws_instance" "web" {
    ami = "${var.ami_id}"
    availability_zone = "${var.aws_default_az}"
    instance_type = "${var.instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.web.id}"]
    associate_public_ip_address = true
    source_dest_check = false

    count = "${var.instance_count}"
    subnet_id = "${element(var.subnet_ids, count.index)}"
    availability_zone = "${element(var.aws_availability_zones, count.index)}"

    tags {
        Name = "${var.proj_prefix}-web${count.index}"
        Desc = "${var.proj_desc}"
        Owner = "${var.proj_owner}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get -y update",
            "sudo apt-get -y install nginx",
            "export HOSTNAME=`hostname`",
            "sudo sed -i 's/nginx!/'$HOSTNAME'/g' /usr/share/nginx/html/index.html",
            "sudo service nginx start"
        ]
        connection {
            user = "ubuntu"
            key_file = "${var.aws_key_path}"
        }
    }
}
output "web_subnet_ids" { value = "${join(",", var.subnet_ids)}" }
