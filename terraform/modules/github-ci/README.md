# Keskne GitHub CI Terraform Module

A module to help access the Keskne GKE cluster from GitHub CI. This creates the following resources:

- Service account
- Workload ID provider that allows GitHub to act as the service account (see [gh-oidc module](https://registry.terraform.io/modules/terraform-google-modules/github-actions-runners/google/latest/submodules/gh-oidc))
- Repository-wide GitHub variables containing the cluster name/location (for the `gcloud` command)
- Repository-wide GitHub secrets containing the service account/workload provider ID

## Usage

This requires that you already have the Google Terraform provider configured (with access to Keskne), as well as the GitHub Terraform provider authenticated to the repository's owner.

Add this to your Terraform, replacing the obvious parts:

```
module "keskne" {
  source                  = "github.com/LucasPickering/keskne//terraform/modules/github-ci"
  github_repository_owner = "Me"
  github_repository       = "my-repository"
  service_account_id      = "my-repository-github-ci-sa"
}
```

Then add this to your deployment CI:

```yaml
- name: Google Cloud auth
  uses: google-github-actions/auth@v0
  with:
    service_account: ${{ secrets.KESKNE_GOOGLE_SERVICE_ACCOUNT }}
    workload_identity_provider: ${{ secrets.KESKNE_GOOGLE_WORKLOAD_ID_PROVIDER }}
- name: Set up Cloud SDK
  uses: google-github-actions/setup-gcloud@v1.1.1
- name: Save kubeconfig
  run: gcloud container clusters get-credentials ${{ vars.KESKNE_CLUSTER_NAME }} --location ${{ vars.KESKNE_CLUSTER_LOCATION }}
```

The names of these GitHub variables are configurable in the module variables.
