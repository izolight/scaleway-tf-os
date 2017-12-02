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

