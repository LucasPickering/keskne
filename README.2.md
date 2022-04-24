# [Keskne](https://translate.google.com/#view=home&op=translate&sl=et&tl=en&text=keskne)

Reverse proxy server for hosting multiple sites on one Kubernetes cluster.

## Server Setup

### Requirements

- [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [helm](https://helm.sh/)
- [doctl](https://github.com/digitalocean/doctl)

### Deploy Cluster

The cluster and DNS rules are defined by the Terraform in `terraform/cluster`

1. `cd terraform/cluster`
1. Create a file `terraform.tfvars` and add the following:

```sh
cloudflare_zone_id = "<cloudflare DNS zone id>"
cloudflare_email = "<cloudflare login email>"
cloudflare_api_token = "<cloudflare API token>"
do_token = "<digitalocean API token>"
```

1. Run `terraform apply` to stand everything up

### Deploy Ingress Pod

Each webapp running on the cluster is responsible for defining its own Kubernetes resources, but we need a central Nginx ingress server to allow each app to create its own ingress routing rules. That is managed via Helm+Terraform here, and lives in `terraform/helm`.

1. A kubectl context should've been created for you while deploying the cluster. Find its name with `kubectl config get-contexts` (should be along th elines of `do-nyc1-keskne`)
   1. If not present, run `doctl kubernetes cluster kubeconfig save keskne`
1. `kubectl config set-context <context name>`
1. `cd terraform/helm`
1. `terraform apply`

```

```
