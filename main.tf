variable "commercial_type" {
  default = "VC1S"
}

variable "architectures" {
  default = {
    C1   = "arm"
    VC1S = "x86_64"
    VC1M = "x86_64"
    VC1L = "x86_64"
    C2S  = "x86_64"
    C2M  = "x86_64"
    C2L  = "x86_64"
  }
}

data "scaleway_image" "centos" {
    architecture    = "${lookup(var.architectures, var.commercial_type)}"
    name            = "CentOS 7.3"
}

provider "scaleway" {}
provider "digitalocean" {}

module "master" {
    source  = "./modules/master"

    type    = "${var.commercial_type}"
    image   = "${data.scaleway_image.centos.id}"
}

module "node" {
    source  = "./modules/node"

    type    = "VC1M"
    image   = "${data.scaleway_image.centos.id}"   
}
