# Simple Web Recipe

This is an example recipe for simple nginx web site.

Edit `.tfvars` file like this:

    proj_prefix = "sw_[DEPLOY ENVIRONMENT]"
    proj_desc = "SimpleWeb [DEPLOY ENVIRONMENT]"

    aws_region = "[AWS REGION]"
    aws_default_az = "[DEFAULT AWS AZ]"
    aws_alter_az = "[ALTERNATIVE AWS AZ]"
    aws_key_path = "[AWS KEY PATH]"
    aws_key_name = "[AWS KEY NAME]"

    default_instance_type = "[AWS DEFAULT INSTANCE TYPE]"
    developer_cidr = "[DEVELOPER'S CIDR FOR SSH CONNECT]"


Then save the file. I recommend naming it with REGION + DENV style. Like this:

    virginia_dev.tfvars


Test your site:

    terraform plan -var-file=virginia_dev.tfvars

And, apply it:

    terraform plan -var-file=virginia_dev.tfvars
