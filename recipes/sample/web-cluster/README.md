# Clustered web recipe

This is an example recipe for clustered nginx web site.

Edit a `.tfvars` file like this:

    proj_prefix = "mw_[DEPLOY ENVIRONMENT]"
    proj_desc = "Minimal Web [DEPLOY ENVIRONMENT]"
    proj_owner = "[OWNER'S EMAIL ADDRESS]"

    aws_region = "[AWS REGION]"
    aws_default_az = "[DEFAULT AWS AZ]"
    aws_alter_az = "[ALTERNATIVE AWS AZ]"
    aws_key_path = "[AWS KEY PATH]"
    aws_key_name = "[AWS KEY NAME]"

    default_instance_type = "[AWS DEFAULT INSTANCE TYPE]"
    developer_cidr = "[DEVELOPER'S CIDR FOR SSH CONNECT]"


Then save the file. I recommend naming it with deploy region + deploy
environment(dev, qa, production, ...) style. Like this:

    virginia_dev.tfvars

Test your site:

    terraform plan -var-file=virginia_dev.tfvars

And, apply it:

    terraform apply -var-file=virginia_dev.tfvars
