variable "do_token" {
	type = "string"
	description = "Digital Oceean API access token"
}

provider "digitalocean" {
	token = "${var.do_token}"
	version = "~> 1"
}

resource "digitalocean_kubernetes_cluster" "ahoy-kube" {
	name    = "ahoy-kube"
	region  = "fra1"
	version = "1.13.4-do.0"

	node_pool {
		name       = "ahoy-kube-pool-1"
		size       = "s-1vcpu-2gb"
		node_count = 2
	}
}

output "kubeconfig" {
	value = "${digitalocean_kubernetes_cluster.ahoy-kube.kube_config.0.raw_config}"
}
