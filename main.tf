provider "aws" {
  region = "ap-south-1"
  profile = "personal"
}

terraform {
  backend "s3" {
    bucket = "nihal-terraform-state"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    profile = "personal"
  }
}

module "network_module"{
  source = "./network_module"
}

module "loadbalancer_module"{
  publicsg_id = "${module.network_module.publicsg_id}"
  source = "./loadbalancer_module"
}

module "autoscaling_module"{
  privatesg_id = "${module.network_module.privatesg_id}"
  tg_arn = "${module.loadbalancer_module.tg_arn}"
  source = "./autoscaling_module"
}