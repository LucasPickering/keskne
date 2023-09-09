# [Keskne](https://translate.google.com/#view=home&op=translate&sl=et&tl=en&text=keskne)

Reverse proxy server for hosting multiple sites on one Kubernetes cluster.

## Server Setup

### Requirements

- [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [gcloud](https://cloud.google.com/sdk/docs/install)
  - Make sure login/authentication is complete
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [helm](https://helm.sh/)

### Deploy Cluster

The cluster, DNS rules, and Kubernetes ingress pod are defined by the Terraform in `./terraform/`

1. `cd terraform`
1. Create a file `terraform.tfvars` and add the following:

```sh
cloudflare_api_token = "<cloudflare API token>"
cloudflare_origin_ca_key = "<cloudflare origin CA key>"
```

Cloudflare token/key comes from https://dash.cloudflare.com/profile/api-tokens

1. Run `terraform apply` to stand everything up

### Kubectl Context

The deployment will **not** create a kubectl context for you. To access the cluster locally, run:

```
gcloud container clusters get-credentials $(terraform output -raw cluster_name) --region $(terraform output -raw gcp_zone)
```

## Troubleshooting

If you get this error when making Terraform changes:

```
Error: Get "http://localhost/api/v1/namespaces/keskne": dial tcp [::1]:80: connect: connection refused
```

You're probably making changes to the cluster and the Kubernetes provider is stupid and can't tear down what it needs to. Just manually unlink whatever Kubernetes/Helm resources it's complaining about with:

```
terraform list
terraform state rm <resource>
```
