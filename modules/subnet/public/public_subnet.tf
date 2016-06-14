/*
    Public subnet
*/

variable "proj_prefix" {}

variable "aws_availability_zones" {}
variable "aws_vpc_id" {}

variable "subnet_cidrs" { default="10.0.0.0/24,10.0.1.0/24" }
variable "count" { default = 1 }


resource "aws_subnet" "public" {
    vpc_id = "${var.aws_vpc_id}"
    count = "${var.count}"
    cidr_block = "${element(split(",", var.subnet_cidrs), count.index)}"
    availability_zone = "${element(var.aws_availability_zones, count.index)}"

    tags {
        Name = "${var.proj_prefix}-public"
    }
}
output "subnet_ids" { value = "${join(",", aws_subnet.public.*.id)}" }


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
    count = "${var.count}"
    subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
    route_table_id = "${aws_route_table.public.id}"
}
