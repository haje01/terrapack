/*
    Public subnet
*/

variable "proj_prefix" {}
variable "aws_default_az" {}
variable "public_subnet_cidr" { default = "10.0.0.0/24" }
variable "aws_vpc_id" {}


resource "aws_subnet" "public" {
    vpc_id = "${var.aws_vpc_id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "${var.aws_default_az}"

    tags {
        Name = "${var.proj_prefix}-public"
    }
}
output "subnet_id" { value = "${aws_subnet.public.id}" }


resource "aws_internet_gateway" "default" {
    vpc_id = "${var.aws_vpc_id}"
}


resource "aws_route_table" "public" {
    vpc_id = "${var.aws_vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "${var.proj_prefix}-public"
    }
}


resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}
