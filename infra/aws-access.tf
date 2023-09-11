resource "aws_iam_user" "mediabanken" {
  name = "mediabanken-${var.env}"
  path = "/terraform/"

  tags = {
    Environment = var.env
  }
}

resource "aws_iam_access_key" "mediabanken" {
  user = aws_iam_user.mediabanken.name
}

resource "aws_iam_user" "rclone" {
  name = "rclone-${var.env}"
  path = "/terraform/"

  tags = {
    Environment = var.env
  }
}

resource "aws_iam_access_key" "rclone" {
  user = aws_iam_user.rclone.name
}

resource "aws_iam_user" "backgroundjobs" {
  name = "backgroundjobs-${var.env}"
  path = "/terraform/"

  tags = {
    Environment = var.env
  }
}

resource "aws_iam_access_key" "backgroundjobs" {
  user = aws_iam_user.backgroundjobs.name
}

resource "aws_iam_user" "api" {
  name = "api-${var.env}"
  path = "/terraform/"

  tags = {
    Environment = var.env
  }
}

resource "aws_iam_access_key" "api" {
  user = aws_iam_user.api.name
}

resource "aws_iam_policy" "vod-ingest-bucket-access-rw" {
  name = "vod-ingest-bucket-rw-${var.env}"
  path = "/buckets/"

  tags = {
    Environment = var.env
  }

  policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Sid : "TF1",
          Effect : "Allow",
          Action : "s3:*",
          Resource : [
            "arn:aws:s3:::${aws_s3_bucket.vod-asset-ingest-bucket.bucket}/*",
            "arn:aws:s3:::${aws_s3_bucket.vod-asset-ingest-bucket.bucket}"
          ]
        }
      ]
  })
}

resource "aws_iam_policy_attachment" "vod-ingest-bucket-rw" {
  name       = "vod-ingest-policy-attachment-${var.env}"
  users      = [aws_iam_user.mediabanken.name, aws_iam_user.backgroundjobs.name, aws_iam_user.rclone.name]
  roles      = [aws_iam_role.mediapackage.name]
  groups     = []
  policy_arn = aws_iam_policy.vod-ingest-bucket-access-rw.arn
}

resource "aws_iam_policy" "mediapackage-rw" {
  name = "mediapackage-rw-${var.env}"
  path = "/mediapackage-vod/"

  tags = {
    Environment = var.env
  }
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "mediapackage-vod:DeleteAsset",
            "mediapackage-vod:DescribePackagingConfiguration",
            "mediapackage-vod:ListTagsForResource",
            "mediapackage-vod:ListPackagingConfigurations",
            "mediapackage-vod:ListAssets",
            "mediapackage-vod:CreateAsset",
            "mediapackage-vod:ListPackagingGroups",
            "mediapackage-vod:DescribePackagingGroup",
            "mediapackage-vod:UntagResource",
            "mediapackage-vod:DescribeAsset",
            "mediapackage-vod:TagResource"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_policy_attachment" "mediapackage-rw" {
  name       = "mediapackage-policy-attachment-${var.env}"
  users      = [aws_iam_user.backgroundjobs.name]
  roles      = [aws_iam_role.mediapackage.name]
  groups     = []
  policy_arn = aws_iam_policy.mediapackage-rw.arn
}

resource "aws_iam_policy" "vod-storage-bucket-access-rw" {
  name = "vod-storage-bucket-rw-${var.env}"
  path = "/buckets/"

  tags = {
    Environment = var.env
  }

  policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Sid : "TF1",
          Effect : "Allow",
          Action : "s3:*",
          Resource : [
            "arn:aws:s3:::${aws_s3_bucket.vod-asset-storage-bucket.bucket}/*",
            "arn:aws:s3:::${aws_s3_bucket.vod-asset-storage-bucket.bucket}"
          ]
        }
      ]
  })
}

resource "aws_iam_policy_attachment" "vod-storage-bucket-rw" {
  name       = "vod-storage-policy-attachment-${var.env}"
  users      = [aws_iam_user.backgroundjobs.name]
  roles      = [aws_iam_role.mediapackage.name]
  groups     = []
  policy_arn = aws_iam_policy.vod-storage-bucket-access-rw.arn
}

resource "aws_iam_policy" "vod-storage-bucket-access-ro" {
  name = "vod-storage-bucket-ro-${var.env}"
  path = "/buckets/"

  tags = {
    Environment = var.env
  }

  policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Sid : "TF1",
          Effect : "Allow",
          Action : [
            "s3:GetLifecycleConfiguration",
            "s3:GetBucketTagging",
            "s3:GetInventoryConfiguration",
            "s3:GetObjectVersionTagging",
            "s3:ListBucketVersions",
            "s3:GetBucketLogging",
            "s3:ListBucket",
            "s3:GetAccelerateConfiguration",
            "s3:GetObjectVersionAttributes",
            "s3:GetBucketPolicy",
            "s3:GetObjectVersionTorrent",
            "s3:GetObjectAcl",
            "s3:GetEncryptionConfiguration",
            "s3:GetBucketObjectLockConfiguration",
            "s3:GetIntelligentTieringConfiguration",
            "s3:GetBucketRequestPayment",
            "s3:GetObjectVersionAcl",
            "s3:GetObjectTagging",
            "s3:GetMetricsConfiguration",
            "s3:GetBucketOwnershipControls",
            "s3:GetBucketPublicAccessBlock",
            "s3:GetBucketPolicyStatus",
            "s3:ListBucketMultipartUploads",
            "s3:GetObjectRetention",
            "s3:GetBucketWebsite",
            "s3:GetObjectAttributes",
            "s3:GetBucketVersioning",
            "s3:GetBucketAcl",
            "s3:GetObjectLegalHold",
            "s3:GetBucketNotification",
            "s3:ListMultipartUploadParts",
            "s3:GetObject",
            "s3:GetObjectTorrent",
            "s3:GetBucketCORS",
            "s3:GetAnalyticsConfiguration",
            "s3:GetObjectVersionForReplication",
            "s3:GetBucketLocation",
            "s3:GetObjectVersion"
          ]
          Resource : [
            "arn:aws:s3:::${aws_s3_bucket.vod-asset-storage-bucket.bucket}/*",
            "arn:aws:s3:::${aws_s3_bucket.vod-asset-storage-bucket.bucket}"
          ]
        }
      ]
  })
}

resource "aws_iam_policy_attachment" "vod-storage-bucket-ro" {
  name       = "vod-storage-policy-attachment-ro-${var.env}"
  users      = [aws_iam_user.mediabanken.name]
  roles      = []
  groups     = []
  policy_arn = aws_iam_policy.vod-storage-bucket-access-ro.arn
}

resource "local_sensitive_file" "mediabanken-key" {
  content = "AWS_ACCESS_KEY_ID=${aws_iam_access_key.mediabanken.id}\nAWS_SECRET_ACCESS_KEY=${aws_iam_access_key
  .mediabanken.secret}"
  filename = "${var.basepath}/keys/mediabanken.secret.env"
}

resource "local_sensitive_file" "rclone-key" {
  content = "AWS_ACCESS_KEY_ID=${aws_iam_access_key.rclone.id}\nAWS_SECRET_ACCESS_KEY=${aws_iam_access_key
  .rclone.secret}"
  filename = "${var.basepath}/keys/rclone.secret.env"
}

////
// MediaPackage Policies
////

resource "aws_iam_role" "mediapackage" {
  name = "mediapackage-${var.env}"

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

output "mediapackage-role-arn" {
  value = aws_iam_role.mediapackage.arn
}


resource "aws_iam_policy" "mediapackage-passrole" {
  name = "mediapackage-passrole-${var.env}"
  path = "/mediapackage/"

  tags = {
    Environment = var.env
  }

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [{
        "Effect" : "Allow",
        "Action" : [
          "iam:GetRole",
          "iam:PassRole"
        ],
        "Resource" : aws_iam_role.mediapackage.arn
      }]
    }
  )
}

resource "aws_iam_policy_attachment" "mediapackage-passrole" {
  name       = "mediapackage-passrole-${var.env}"
  users      = [aws_iam_user.backgroundjobs.name]
  roles      = []
  groups     = []
  policy_arn = aws_iam_policy.mediapackage-passrole.arn
}
