# terraform-aws-eks-velero

## Example usage:

```terraform
module "velero" {
  source         = "git@github.com:kabisa/terraform-aws-eks-velero.git?ref=0.1"
  schedule       = "5 3 * * *"
  ttl            = "240h"
  account_id     = var.account_id
  bucket_name    = "${module.label.id}-velero-bucket"
  namespaces     = ["yourfavorite-namespace"]
  oidc_host_path = module.eks_openid_connect.oidc_host_path
  tags           = module.label.tags
  prefix         = "application-name-maybe"
  region         = var.region
}
```
