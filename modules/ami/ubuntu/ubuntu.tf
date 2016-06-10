variable "region" {}
variable "amis" { 
    description = "AMIs for Ubuntu Server 14.04 LTS (HVM)"
    default = {
        us-east-1 = "ami-fce3c696"  # Virginia
        us-west-1 = "ami-9abea4fb"  # Oregon
        eu-central-1 = "ami-87564feb"  # Frankfurt
        ap-northeast-1 = "ami-a21529cc"  # Tokyo
        ap-northeast-2 = "ami-09dc1267"  # Seoul
        ap-southeast-1 = "ami-25c00c46"  # Singapore
    }   
}       

output id { value = "${lookup(var.amis, var.region)}" }
