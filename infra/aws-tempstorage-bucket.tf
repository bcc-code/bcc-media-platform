resource "aws_s3_bucket" "btv-tempstorage" {
  bucket = "btv-tempstorage-${var.env}"

  tags = {
    Name        = "Files tempstorage by the BTV Platform"
    Environment = var.env
  }

}

resource "aws_s3_bucket_lifecycle_configuration" "btv-tempstorage-lifecycle" {
  bucket = aws_s3_bucket.btv-tempstorage.bucket

  rule {
    id     = "btv-tempstorage-${var.env}-expire-dbexport"
    status = "Enabled"
    filter {} // All objects
    expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket_acl" "btv-tempstorage-acl" {
  bucket = aws_s3_bucket.btv-tempstorage.bucket
  acl    = "private"
}

resource "aws_iam_policy" "tempstorage-bucket-access-rw" {
  name = "btv-tempstorage-bucket-bucket-rw-${var.env}"
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
            "arn:aws:s3:::${aws_s3_bucket.btv-tempstorage.bucket}/*",
            "arn:aws:s3:::${aws_s3_bucket.btv-tempstorage.bucket}"
          ]
        }
      ]
  })
}

resource "aws_iam_policy_attachment" "btv-tempstorage-bucket-rw" {
  name       = "btv-tempstorage-policy-attachment-${var.env}"
  users      = [aws_iam_user.api.name]
  roles      = []
  groups     = []
  policy_arn = aws_iam_policy.tempstorage-bucket-access-rw.arn
}
