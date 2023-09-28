variable "region" {
    description = "AWS region where resources will be created"
    default     = "us-east-1"
}
variable "profile" {
    description = "The profile to be used for access into the aws account"
    default = "mariyam"
}
variable "vpc_id" {
    description = "The VPC id of the VPC to be used"
    default = "vpc-074f9b20940a76b20"
}
variable "subnet_id1" {
    description = "The subnet id of the subnet to be used"
    default = "subnet-012eae93ca971247f" #us-east-1a
}
variable "subnet_id2" {
    description = "The subnet id of another subnet to be used"
    default = "subnet-0ad66ec9de9f07af8" #us-east-1c
}
variable "key_name"{
    description = "The key pair name for connecting to the ec2 instance"
    default = "devops-login"
}
variable "ami_id" {
    description = "The ami to be used for the EC2 instances created"
    default = "ami-00c6177f250e07ec1" #Amazon linux 2(HVM)
}
variable "instance_type" {
    description = "EC2 instance type for the Auto Scaling Group"
    default     = "t2.micro"
}
variable "desired_capacity" {
    description = "Desired number of instances in the Auto Scaling Group"
    default     = 3
}
variable "min_size" {
    description = "Minimum number of instances in the Auto Scaling Group"
    default     = 2
}
variable "max_size" {
    description = "Maximum number of instances in the Auto Scaling Group"
    default     = 4
}

