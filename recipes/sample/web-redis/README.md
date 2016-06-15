# Web + Redis sample recipe

This is an example recipe for clusterd nginx + redis web site.

Edit a `.tfvars` file like this:

    proj_prefix = "wr_[DEPLOY ENVIRONMENT]"
    proj_desc = "Web + Redis [DEPLOY ENVIRONMENT]"
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


This site has private subnet, where redis instance is located. You can log into the redis instance by [SSH agent forwarding](https://blogs.aws.amazon.com/security/post/Tx3N8GFK85UN1G6/Securely-connect-to-Linux-instances-running-in-a-private-Amazon-VPC)

    ssh -A ec2-user@[BASTION IP] -i [YOUR KEY PATH]
