# [Keskne](https://translate.google.com/#view=home&op=translate&sl=et&tl=en&text=keskne)

Reverse proxy server for hosting multiple sites on one Kubernetes cluster.

## Server Setup

### Requirements

- [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [helm](https://helm.sh/)
- [doctl](https://github.com/digitalocean/doctl)

### Deploy Cluster

The cluster, DNS rules, and Kubernetes ingress pod are defined by the Terraform in `./terraform/`

1. `cd terraform`
1. Create a file `terraform.tfvars` and add the following:

```sh
cloudflare_api_token = "<cloudflare API token>"
cloudflare_origin_ca_key = "<cloudflare origin CA key>"
do_token = "<digitalocean API token>"
```

Cloudflare token/key comes from https://dash.cloudflare.com/profile/api-tokens

1. Run `terraform apply` to stand everything up

### Kubectl Context

The deployment Terraform will create a `kubectl` context called `keskne`. It won't select the context though, so you'll have to run `kubectl config set-context keskne` to run any `kubectl` commands against the cluster.

If you need to access the cluster but didn't run the Terraform originally, you can create the context manually with the `doctl` tool (requires login first):

```sh
doctl kubernetes cluster kubeconfig save keskne --context keskne
```
