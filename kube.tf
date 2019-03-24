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

provider "kubernetes" {
	host = "${digitalocean_kubernetes_cluster.ahoy-kube.endpoint}"

	client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.ahoy-kube.kube_config.0.client_certificate)}"
	client_key             = "${base64decode(digitalocean_kubernetes_cluster.ahoy-kube.kube_config.0.client_key)}"
	cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.ahoy-kube.kube_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_deployment" "kubernetes-bootcamp" {
  metadata {
    name = "kubernetes-bootcamp"
  }

  spec {
    replicas = 4

    selector {
      match_labels {
        dummy = "dummy"
      }
    }

    template {
      metadata {
        labels {
          dummy = "dummy"
        }
      }
      spec {
        container {
          image = "gcr.io/google-samples/kubernetes-bootcamp:v1"
          name  = "kubernetes-bootcamp"
        }
      }
    }
  }
}
