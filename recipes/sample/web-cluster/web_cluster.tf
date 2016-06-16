/*
    Web cluster sample recipe
*/

variable "proj_prefix" {}
variable "proj_desc" {}
variable "proj_owner" {}

variable "aws_key_path" {}
variable "aws_key_name" {}
variable "aws_region" {}
variable "aws_availability_zones" {}

variable "nginx_ami" {}
variable "default_instance_type" {}
variable "developer_cidr" {}


provider "aws" {
    region = "${var.aws_region}"
}


module "public_only_vpc" {
    source = "../../../modules/vpc/public_only"
    proj_prefix = "${var.proj_prefix}"
    aws_availability_zones = "${var.aws_availability_zones}"
    subnet_count = 2
}
output "public_subnet_ids" { value = "${module.public_only_vpc.subnet_ids}" }


module "security_group" {
    source = "../../../modules/securitygroup/web/developer"
    proj_prefix = "${var.proj_prefix}"
    proj_desc = "${var.proj_desc}"
    proj_owner = "${var.proj_owner}"
    
    developer_cidr = "${var.developer_cidr}"
    vpc_id = "${module.public_only_vpc.vpc_id}"
}


module "web" {
    source = "../../../modules/sample/nginx_cluster"
    proj_prefix = "${var.proj_prefix}"
    proj_desc = "${var.proj_desc}"
    proj_owner = "${var.proj_owner}"

    aws_availability_zones = "${var.aws_availability_zones}"
    aws_key_name = "${var.aws_key_name}"
    aws_key_path = "${var.aws_key_path}"

    nginx_ami = "${var.nginx_ami}"
    instance_type = "${var.default_instance_type}"
    vpc_id = "${module.public_only_vpc.vpc_id}"
    subnet_ids = "${module.public_only_vpc.subnet_ids}"
    security_group = "${module.security_group.id}"
    instance_count = 3
}
output "web_subnet_ids" { value = "${module.web.web_subnet_ids}" }
output "vpc_subnet_ids" { value = "${module.public_only_vpc.subnet_ids}" }
