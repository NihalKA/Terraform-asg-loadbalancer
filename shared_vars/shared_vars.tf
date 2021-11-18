

locals{
    env = "${terraform.workspace}"

    vpcid_env = {
        default = "vpc-2ec92a45"
        staging = "vpc-2ec92a45"
        production = "vpc-2ec92a45"
    }

    vpcid = "${lookup(local.vpcid_env, local.env)}"

    publicsubnetid1_env = {
        default = "	subnet-de5fdfa5"
        staging = "subnet-de5fdfa5"
        production = "subnet-de5fdfa5"
    }

    publicsubnetid1 = "${lookup(local.publicsubnetid1_env, local.env)}"
    
    publicsubnetid2_env = {
        default = "subnet-0bf58b47"
        staging = "subnet-0bf58b47"
        production = "subnet-0bf58b47"
    }

    publicsubnetid2 = "${lookup(local.publicsubnetid2_env, local.env)}"

    privatesubnetid_env = {
        default = "subnet-1c464e74"
        staging = "subnet-1c464e74"
        production = "subnet-1c464e74"
    }

    privatesubnetid = "${lookup(local.privatesubnetid_env, local.env)}"
}

output "vpcid" {
    value = "${local.vpcid}"
}
output "publicsubnetid1" {
    value = "${local.publicsubnetid1}"
}
output "publicsubnetid2" {
    value = "${local.publicsubnetid2}"
}
output "privatesubnetid" {
    value = "${local.privatesubnetid}"
}

output "env_suffix"{
    value = "${local.env}"
}