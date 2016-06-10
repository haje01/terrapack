variable "region" {}
variable "amis" { 
    description = "AMIs for Ubuntu Server 14.04 LTS (HVM)"
    default = {
        us-east-1 = "ami-fce3c696"  # Virginia
        eu-central-1 = "ami-87564feb"  # Frankfurt
        ap-northeast-2 = "ami-09dc1267"  # Seoul
    }   
}       

output id { value = "${lookup(var.amis, var.region)}" }
