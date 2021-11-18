module "shared_vars" {
    source = "../shared_vars"
}

variable privatesg_id{

}
variable tg_arn{

}


locals{
    env = "${terraform.workspace}"

    amiid_env = {
        default = "ami-0567e0d2b4b2169ae5"
        staging = "ami-0567e0d2b4b2169ae"
        production = "ami-0567e0d2b4b2169ae"
    }

    amiid = "${lookup(local.amiid_env, local.env)}"
    
    instancetype_env = {
        default = "t2.micro"
        staging = "t2.micro"
        production = "t2.small"
    }

    instancetype = "${lookup(local.instancetype_env, local.env)}"

    keypair_env = {
        default = "cfn-key-1"
        staging = "cfn-key-1"
        production = "cfn-key-2"
    }

    keypairname = "${lookup(local.keypair_env, local.env)}"

    asgdesired_env = {
        default = "1"
        staging = "1"
        production = "2"
    }

    asgdesired = "${lookup(local.asgdesired_env, local.env)}"

    asgmin_env = {
        default = "1"
        staging = "1"
        production = "2"
    }

    asgmin = "${lookup(local.asgmin_env, local.env)}"

    asgmax_env = {
        default = "2"
        staging = "2"
        production = "3"
    }

    asgmax = "${lookup(local.asgmax_env, local.env)}"


}

output "amiid" {
    value = "${local.amiid}"
}

output "instancetype" {
    value = "${local.instancetype}"
}

output "keypairname" {
    value = "${local.keypairname}"
}



resource "aws_launch_configuration" "sampleapp_lc"{
  name          = "sampleapp-lc-${local.env}"
  image_id      = "${local.amiid}"
  instance_type = "${local.instancetype}"
  key_name = "${local.keypairname}"
  user_data = "${file("./assets/userdata.txt")}"
  security_groups = ["${var.privatesg_id}"]
  
}


resource "aws_autoscaling_group" "sampleapp_asg" {
  name                 = "sampleapp-asg-${module.shared_vars.env_suffix}"
  max_size             = "${local.asgmax}"
  min_size             = "${local.asgmin}"
  desired_capacity     = "${local.asgdesired}"
  launch_configuration = aws_launch_configuration.sampleapp_lc.name
  vpc_zone_identifier  = ["${module.shared_vars.publicsubnetid2}"]
  target_group_arns    = ["${var.tg_arn}"]

  tags = concat(
    [
      {
        "key"                 = "Name"
        "value"               = "sampleapp-${module.shared_vars.env_suffix}"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "Environment"
        "value"               = "${module.shared_vars.env_suffix}"
        "propagate_at_launch" = true
      },
    ],
    #var.extra_tags,
  )
}