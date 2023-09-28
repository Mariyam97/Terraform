provider "aws" {
    profile = "${var.profile}"
    region = "${var.region}"
}
resource "aws_security_group" "nginx_sg" {


    name               = "nginx_sg"
    description        = "Security group for the Nginx instances to be created"
    vpc_id             = "${var.vpc_id}"
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }
  
}


resource "aws_instance" "instance_1" {
    ami = "${var.ami_id}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = ["${aws_security_group.nginx_sg.id}"]
    key_name = "${var.key_name}"
    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo amazon-linux-extras install nginx1 -y 
                sudo systemctl enable nginx
                sudo systemctl start nginx
                EOF
    subnet_id = "${var.subnet_id1}"


    tags = {
      Name = "instance_1"
    }
}
resource "aws_launch_template" "devops_launch_template" {
    name_prefix   = "devops_ltemp_"
    image_id      = "${var.ami_id}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = ["${aws_security_group.nginx_sg.id}"]
    user_data = filebase64("script.sh")
}


resource "aws_autoscaling_group" "asg_devops" {
    name_prefix         = "devops_asg_"
    min_size            = "${var.min_size}"
    max_size            = "${var.max_size}"
    desired_capacity    = "${var.desired_capacity}"
    vpc_zone_identifier = ["${var.subnet_id1}", "${var.subnet_id2}"]
    launch_template {
    id      = "${aws_launch_template.devops_launch_template.id}"
    }
}


resource "aws_lb" "devops_lb" {
    name               = "devops-nginx-lb"
    internal           = false
    load_balancer_type = "application"
    subnets            = ["${var.subnet_id1}", "${var.subnet_id2}"] 
}


resource "aws_lb_target_group" "devops_lb_tg" {
    name     = "devops-nginx-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = "${var.vpc_id}" 
}


resource "aws_lb_listener" "devops_lb_listener" {
    load_balancer_arn = "${aws_lb.devops_lb.arn}"
    port              = 80
    protocol          = "HTTP"


    default_action {
        target_group_arn = "${aws_lb_target_group.devops_lb_tg.arn}"
        type             = "forward"
    }
}


output "load_balancer_dns" {
    value = "${aws_lb.devops_lb.dns_name}"
}
