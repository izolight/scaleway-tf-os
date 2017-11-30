variable "image" {}

variable "type" {}

resource "scaleway_server" "jumphost" {
    name    = "master-0"
    image   = "${var.image}"
    type    = "${var.type}"
    dynamic_ip_required = true
    enable_ipv6 = true

    tags = ["master", "jump_host"]
}

resource "scaleway_server" "masters" {
    count   = "2"
    image   = "${var.image}"
    type    = "${var.type}"
    name    = "master-${count.index+1}"
    enable_ipv6 = true

    tags = ["master"]
}

resource "scaleway_ip" "jumphost" {
    server = "${scaleway_server.jumphost.id}"
}

output "public_ip" {
    value = "${scaleway_ip.jumphost.ip}"
}
