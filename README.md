# Ahoy Kube!

Kubernetes playground

## Deployment

`kube.tf` file defines small cluster (2 nodes 1cpu/2gb) on Digital Ocean.

Copy `kube.tfvars` into `kube.tf` and fill in `do_token`  variable. Afterwards:

    # Create cluster
    terraform apply -var-file=kube.tfvars

    # Retrieve configuration
    terraform output kubeconfig >kubeconfig.yaml

    # Check cluster info
    kubectl --kubeconfig=kubeconfig.yaml cluster-info

    # Destroy cluster
    terraform destroy -var-file=kube.tfvars
