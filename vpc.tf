resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "${var.project}-defaul"
        Project = "${var.project}"
    }
}


resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}


/*
    Bastion(NAT) Instance
*/
resource "aws_security_group" "bastion" {
    name = "${var.project}-bastion"
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

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "${var.project}-bastion"
        Project = "${var.project}"
    }
}


resource "aws_instance" "bastion" {
    ami = "ami-0d32fa63"  # Seoul/Amazon Linux AMI 2016.03.1 x86_64 VPC NAT HVM EBS
    availability_zone = "${var.aws_default_az}"
    instance_type = "${var.default_instance}"
    key_name = "${var.aws_key_name}"
    security_groups = ["${aws_security_group.bastion.id}"]
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "${var.project}-bastion"
        Project = "${var.project}"
    }
}


resource "aws_eip" "bastion" {
    instance = "${aws_instance.bastion.id}"
    vpc = true
}



/*
    Public Subnet
*/
resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "${var.aws_default_az}"

    tags {
        Name = "${var.project}-public"
        Project = "${var.project}"
    }
}


resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "${var.project}-public"
    }
}


resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}


/*
    Private Subnet
*/
resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "${var.aws_default_az}"

    tags {
        Name = "${var.project}-private"
        Project = "${var.project}"
    }
}


resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.bastion.id}"
    }

    tags {
        Name = "${var.project}-private"
    }
}


resource "aws_route_table_association" "private" {
    subnet_id = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private.id}"
}
