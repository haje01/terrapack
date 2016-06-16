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
variable "redis_ami" {}
variable "nginx_ami" {}


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


module "security_group" {
    source = "../../../modules/securitygroup/web/developer"
    proj_prefix = "${var.proj_prefix}"
    proj_desc = "${var.proj_desc}"
    proj_owner = "${var.proj_owner}"
    
    developer_cidr = "${var.developer_cidr}"
    vpc_id = "${module.public_private_vpc.vpc_id}"
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
    security_group = "${module.security_group.id}"
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

    redis_ami = "${var.redis_ami}"
    app_security_group = "${module.security_group.id}"
    bastion_security_group = "${module.public_private_vpc.bastion_security_group}"
    instance_type = "${var.default_instance_type}"
    vpc_id = "${module.public_private_vpc.vpc_id}"
    subnet_ids = "${module.public_private_vpc.public_subnet_ids}"
}
