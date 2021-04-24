variable "ssh_ip_range" {
    type = string
    description = "The SSH IP address ou IP range to be used while acessing SSH. e. g. 192.168.0.1/32 or 192.168.0.1/24."
}

variable "aws_region" {
    type = string
    description = "The AWS region name. e. g. us-east-1."
}