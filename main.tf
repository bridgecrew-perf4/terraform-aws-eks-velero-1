# S3 bucket policy
data "aws_iam_policy_document" "backup_bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.velero-iam-role.arn]
    }
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
    ]
  }
}


resource "aws_s3_bucket" "backup-bucket" {
  bucket = var.bucket_name
  acl    = "private"

  # policy = data.aws_iam_policy_document.policy.json
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}

data "template_file" "velero-values" {
  template = file("${path.module}/yamls/velero-values.yaml")
  vars = {
    provider      = "aws"
    bucket        = var.bucket_name
    prefix        = var.prefix
    account_id    = var.account_id
    region        = var.region
    iam_role_name = aws_iam_role.velero-iam-role.name
    schedules_json = jsonencode({
      sentry-backup : {
        schedule = var.schedule
        template = {
          ttl                = var.ttl,
          includedNamespaces = var.namespaces
        }
      }
    })
  }
}

# 2.14.1 => appVersion: 1.5.2
resource "helm_release" "velero" {
  namespace        = var.velero_namespace
  name             = "velero"
  chart            = "velero"
  create_namespace = true
  version          = "2.14.1"
  repository       = "https://vmware-tanzu.github.io/helm-charts"
  values           = [data.template_file.velero-values.rendered]
}