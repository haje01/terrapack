# Building images

In this folder, you can find packer templates to build various images.

Make a variable file for your necessity in following form:

    {
        "aws_region": "[AWS REGION]"
        "aws_instance_type": "[AWS INSTANCE TYPE]",
        "source_ami": "[AMI ID]",
        "ami_name": "[BAKED AMI NAME]",
        "ssh_username": "[SSH USER NAME]"
        "proj_prefix": "[SIMPLE PROJECT PREFIX]",
        "proj_desc": "[DETAILED PROJECT DESCRIPTION]",
        "proj_owner": "[BUILD OWNER's EMAIL]",
        "deploy_env": "[DEPLOY ENVIRONMENT(dev, qa, live, etc..)]"
    }

I suggest you to save the file like `var-[REGION]_[DEPLOY ENVIRONMENT].json`. For example:

    var-virginia_dev.json

  
Build image by packer:

    packer build -var-file=var-virginia_dev.json [PACKER TEMPLATE FILE(.json)]

If your build was successful, you can find the image id at output. Fill the id into terraform recipe's variable file(`.tfvars`), then deploy.
