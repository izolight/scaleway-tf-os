variable "commercial_type" {
  default = "VC1S"
}

variable "domain" {}

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

data "scaleway_bootscript" "main" {
    name = "x86_64 mainline 4.15.11 rev1"
}

provider "scaleway" {
    region  = "ams1"
}

provider "digitalocean" {}

module "master" {
    source  = "./modules/master"

    domain  = "${var.domain}"
    type    = "${var.commercial_type}"
    image   = "${data.scaleway_image.centos.id}"
    bootscript = "${data.scaleway_bootscript.main.id}"
}

module "node" {
    source  = "./modules/node"

    domain  = "${var.domain}"
    type    = "VC1M"
    image   = "${data.scaleway_image.centos.id}"   
    bootscript = "${data.scaleway_bootscript.main.id}"
}
