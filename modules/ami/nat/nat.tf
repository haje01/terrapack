variable "region" {}
variable "amis" { 
    description = "AMIs for Amazon Linux NAT"
    default = {
        us-east-1 = "ami-8d8976e0"  # Virginia
        eu-central-1 = "ami-b2c321dd"  # Frankfurt
        ap-northeast-2 = "ami-0d32fa63"  # Seoul
    }   
}       

output id { value = "${lookup(var.amis, var.region)}" }
