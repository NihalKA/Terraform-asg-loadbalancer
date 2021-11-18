module "shared_vars" {
   source =  "../shared_vars" 
}

# create security groups for ec2

resource "aws_security_group" "publicsg" {
  name        = "publicsg_${module.shared_vars.env_suffix}"
  description = "public sg for ELB ${module.shared_vars.env_suffix}"
  vpc_id      = "${module.shared_vars.vpcid}"
  

  ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      self = null

      
    },
    {
      description      = "TLS from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      self = null

      
    }
  ]

  egress = [
    {
      description      = "outbound of terraform_sg1"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      self = null
      
    }
  ]

  tags = {
    Name = "public sg"
  }
}


//private sg

resource "aws_security_group" "privatesg" {
  name        = "privatesg_${module.shared_vars.env_suffix}"
  description = "private sg for ELB ${module.shared_vars.env_suffix}"
  vpc_id      = "${module.shared_vars.vpcid}"

  ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      self = null
      security_groups = ["${aws_security_group.publicsg.id}"]

      
    },
    {
      description      = "TLS from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      self = null
      security_groups = ["${aws_security_group.publicsg.id}"]

      
    }
  ]

  egress = [
    {
      description      = "outbound of terraform_sg1"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids = null
      security_groups = null
      self = null
      
    }
  ]

  tags = {
    Name = "private sg"
  }
}

output "publicsg_id" {
    value = "${aws_security_group.publicsg.id}"
}

output "privatesg_id" {
    value = "${aws_security_group.privatesg.id}"
}