variable "image" {}

variable "type" {}

variable "domain" {}

variable "bootscript" {}

resource "scaleway_server" "masters" {
    count   = "3"
    image   = "${var.image}"
    bootscript = "${var.bootscript}"
    type    = "${var.type}"
    name    = "master-${count.index}"
    dynamic_ip_required = true
    enable_ipv6 = true

    tags = ["master"]
}

resource "digitalocean_record" "masters" {
    count       = "3"
    domain      = "${var.domain}"
    type        = "CNAME"
    name        = "master-${count.index}.os"
    value       = "${scaleway_server.masters.*.id[count.index]}.pub.cloud.scaleway.com."
    ttl         = "3600"
}

resource "digitalocean_record" "masters_int" {
    count       = "3"
    domain      = "${var.domain}"
    type        = "CNAME"
    name        = "master-${count.index}.int.os"
    value       = "${scaleway_server.masters.*.id[count.index]}.priv.cloud.scaleway.com."
    ttl         = "3600"
}
