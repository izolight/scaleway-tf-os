variable "image" {}

variable "type" {}

resource "scaleway_server" "nodes" {
    count   = "3"
    image   = "${var.image}"
    type    = "${var.type}"
    name    = "node-${count.index}"
    enable_ipv6 = true

    tags = ["node"]
    
    volume = {
        type = "l_ssd"
        size_in_gb = 50
    }
}
