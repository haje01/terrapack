/*
    Web-redis sample recipe
*/

variable "proj_prefix" {}
variable "proj_desc" {}
variable "proj_owner" {}

variable "aws_key_path" {}
variable "aws_key_name" {}
variable "aws_region" {}
variable "aws_availability_zones" {}

variable "default_instance_type" {}
variable "developer_cidr" {}


provider "aws" {
    region = "${var.aws_region}"
}


module "public_private_vpc" {
    source = "../../../modules/vpc/public_private"
    proj_prefix = "${var.proj_prefix}"
    proj_desc = "${var.proj_desc}"
    proj_owner = "${var.proj_owner}"

    aws_region = "${var.aws_region}"
    aws_availability_zones = "${var.aws_availability_zones}"
    aws_key_name = "${var.aws_key_name}"

    bastion_instance_type = "${var.default_instance_type}"
    developer_cidr = "${var.developer_cidr}"
    public_subnet_count = 2
    private_subnet_count = 1
}
output "public_subnet_ids" { value = "${module.public_private_vpc.public_subnet_ids}" }


module "ubuntu_ami" {
  source = "../../../modules/ami/ubuntu"
  region = "${var.aws_region}"
}


module "web" {
    source = "../../../modules/sample/nginx_cluster"
    proj_prefix = "${var.proj_prefix}"
    proj_desc = "${var.proj_desc}"
    proj_owner = "${var.proj_owner}"

    aws_availability_zones = "${var.aws_availability_zones}"
    aws_key_name = "${var.aws_key_name}"
    aws_key_path = "${var.aws_key_path}"

    ami_id = "${module.ubuntu_ami.id}"
    developer_cidr = "${var.developer_cidr}"
    instance_type = "${var.default_instance_type}"
    vpc_id = "${module.public_private_vpc.vpc_id}"
    subnet_ids = "${module.public_private_vpc.public_subnet_ids}"
    instance_count = 3
}


module "redis" {
    source = "../../../modules/sample/redis"
    proj_prefix = "${var.proj_prefix}"
    proj_desc = "${var.proj_desc}"
    proj_owner = "${var.proj_owner}"

    aws_availability_zones = "${var.aws_availability_zones}"
    aws_key_name = "${var.aws_key_name}"
    aws_key_path = "${var.aws_key_path}"

    ami_id = "${module.ubuntu_ami.id}"
    app_security_group = "${module.web.security_group}"
    bastion_security_group = "${module.public_private_vpc.bastion_security_group}"
    instance_type = "${var.default_instance_type}"
    vpc_id = "${module.public_private_vpc.vpc_id}"
    subnet_ids = "${module.public_private_vpc.public_subnet_ids}"
}
