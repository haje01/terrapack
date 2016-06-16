/*
    NGINX Sample
*/
variable proj_prefix {}
variable proj_desc {}
variable proj_owner {}

variable aws_key_name {}
variable aws_key_path {}
variable aws_default_az {}

variable user_cidr { default = "0.0.0.0/0" }
variable developer_cidr {}
variable instance_type {}
variable subnet_id {}
variable vpc_id {}
variable nginx_ami{}


module "security_group" {
    source = "../../../modules/securitygroup/web/developer"

    proj_prefix = "${var.proj_prefix}"
    proj_desc = "${var.proj_desc}"
    proj_owner = "${var.proj_owner}"

    user_cidr = "${var.user_cidr}"
    developer_cidr = "${var.developer_cidr}"
    vpc_id = "${var.vpc_id}"
}


resource "aws_instance" "web" {
    ami = "${var.nginx_ami}"
    availability_zone = "${var.aws_default_az}"
    instance_type = "${var.instance_type}"
    key_name = "${var.aws_key_name}"
    security_groups = ["${module.security_group.id}"]
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "${var.proj_prefix}-web"
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
