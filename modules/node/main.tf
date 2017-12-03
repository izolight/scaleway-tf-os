variable "image" {}

variable "type" {}

resource "scaleway_server" "infra" {
    image   = "${var.image}"
    type    = "${var.type}"
    name    = "infra"
    enable_ipv6 = true

    tags = ["node", "infra"]

    volume = {
        type = "l_ssd"
        size_in_gb = 50
    }
}

resource "scaleway_ip" "infra" {
    server = "${scaleway_server.infra.id}"
}

resource "digitalocean_record" "infra" {
    domain      = "***REMOVED***"
    type        = "CNAME"
    name        = "infra.os"
    value       = "${scaleway_server.infra.id}.pub.cloud.scaleway.com."
    ttl         = "3600"
}

resource "digitalocean_record" "infra_int" {
    domain      = "***REMOVED***"
    type        = "CNAME"
    name        = "infra.int.os"
    value       = "${scaleway_server.infra.id}.priv.cloud.scaleway.com."
    ttl         = "3600"
}

resource "digitalocean_record" "lb_main" {
    domain      = "***REMOVED***"
    type        = "A"
    name        = "os"
    value       = "${scaleway_server.infra.public_ip}"
    ttl         = "3600"
}

resource "digitalocean_record" "lb_sub" {
    domain      = "***REMOVED***"
    type        = "CNAME"
    name        = "*.os"
    value       = "infra.os.***REMOVED***."
    ttl         = "3600"
}


resource "scaleway_server" "nodes" {
    count   = "3"
    image   = "${var.image}"
    type    = "${var.type}"
    name    = "node-${count.index}"
    dynamic_ip_required = true
    enable_ipv6 = true

    tags = ["node"]
    
    volume = {
        type = "l_ssd"
        size_in_gb = 50
    }
}

resource "digitalocean_record" "nodes" {
    count       = "3"
    domain      = "***REMOVED***"
    type        = "CNAME"
    name        = "node-${count.index}.os"
    value       = "${scaleway_server.nodes.*.id[count.index]}.pub.cloud.scaleway.com."
    ttl         = "3600"
}

resource "digitalocean_record" "nodes_int" {
    count       = "3"
    domain      = "***REMOVED***"
    type        = "CNAME"
    name        = "node-${count.index}.int.os"
    value       = "${scaleway_server.nodes.*.id[count.index]}.priv.cloud.scaleway.com."
    ttl         = "3600"
}
