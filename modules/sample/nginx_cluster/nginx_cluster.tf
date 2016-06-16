/*
    NGINX Sample
*/
variable proj_prefix {}
variable proj_desc {}
variable proj_owner {}

variable aws_key_name {}
variable aws_key_path {}
variable aws_availability_zones {}

variable security_group {}
variable user_cidr { default = "0.0.0.0/0" }
variable instance_type {}
variable subnet_ids {}
variable vpc_id {}
variable nginx_ami {}
variable instance_count {}


module "elb" {
    source = "../../../modules/elb"
    proj_prefix = "${var.proj_prefix}"
    proj_desc = "${var.proj_desc}"
    proj_owner = "${var.proj_owner}"
    vpc_id = "${var.vpc_id}"
    subnet_ids = "${split(",", var.subnet_ids)}"
    instances = "${join(",", aws_instance.web.*.id)}"
    user_cidr = "${var.user_cidr}"
    from_port = 80
    to_port = 80
}


resource "aws_instance" "web" {
    ami = "${var.nginx_ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${var.security_group}"]
    associate_public_ip_address = true
    source_dest_check = false

    count = "${var.instance_count}"
    subnet_id = "${element(split(",", var.subnet_ids), count.index)}"
    availability_zone = "${element(split(",", var.aws_availability_zones), count.index)}"

    tags {
        Name = "${var.proj_prefix}-web${count.index + 1}"
        Desc = "${var.proj_desc}"
        Owner = "${var.proj_owner}"
    }
}
output "web_subnet_ids" { value = "${var.subnet_ids}" }
