variable "image" {}

variable "type" {}

resource "scaleway_server" "masters" {
    count   = "3"
    image   = "${var.image}"
    type    = "${var.type}"
    name    = "master-${count.index}"
    dynamic_ip_required = true
    enable_ipv6 = true

    tags = ["master"]
}

resource "digitalocean_record" "masters" {
    count       = "3"
    domain      = "***REMOVED***"
    type        = "CNAME"
    name        = "master-${count.index}.os"
    value       = "${scaleway_server.masters.*.id[count.index]}.pub.cloud.scaleway.com."
    ttl         = "3600"
}

