

resource "aws_secretsmanager_secret" "cdn_auth" {
  name = "mediapackage/cdn_auth_${var.env}"
  tags = {
    "Environment" = var.env
  }
}

resource "random_uuid" "cdn_auth_secret" {}

resource "aws_secretsmanager_secret_version" "cdn_auth" {
  secret_id = aws_secretsmanager_secret.cdn_auth.id
  secret_string = jsonencode({
    "MediaPackageCDNIdentifier" : random_uuid.cdn_auth_secret.result
  })
}

resource "aws_iam_role" "cdn_auth" {
  name = "cdn-auth-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "mediapackage.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "cdn_auth" {
  name   = "cdn-auth-policy-${var.env}"
  role   = aws_iam_role.cdn_auth.id
  policy = data.aws_iam_policy_document.cdn_auth.json
}

data "aws_iam_policy_document" "cdn_auth" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecrets",
      "secretsmanager:ListSecretVersionIds",
    ]
    resources = [
      aws_secretsmanager_secret.cdn_auth.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:GetRole",
      "iam:PassRole"
    ]
    resources = [
      aws_iam_role.cdn_auth.arn
    ]
  }
}
