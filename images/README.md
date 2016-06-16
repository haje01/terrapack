# Packs

In this folder, you can find packer templates to build various images.

Make a variable file for your necessity in following form:

    {
        "aws_region": "[AWS REGION]"
        "aws_instance_type": "[AWS INSTANCE TYPE]",
        "source_ami": "[AMI ID]",
        "ami_name": "[BAKED AMI NAME]",
        "ssh_username": "[SSH USER NAME]"
    }

I suggest you to save the file like `var-[REGION]_[DEPLOY ENVIRONMENT].json`. For example:

    var-virginia_dev.json

  
Build image by packer:

    packer build -var-file=var-virginia_dev.json TEMPLATE

If your build was successful, you can find the image id at output. Fill the id into terraform recipe's variable file(`.tfvars`), then deploy.
