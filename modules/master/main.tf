variable "image" {}

variable "type" {}

resource "scaleway_server" "masters" {
    count   = "2"
    image   = "${var.image}"
    type    = "${var.type}"
    name    = "master-${count.index}"
    enable_ipv6 = true

    tags = ["master"]
}

