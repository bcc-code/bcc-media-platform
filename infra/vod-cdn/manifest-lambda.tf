module "manifest_lambda" {
  providers = {
    aws = aws.us_east_1
  }
  source                 = "./lambda"
  name                   = "manifest-${var.env}"
  description            = ""
  runtime                = "nodejs16.x"
  lambda_code_source_dir = "${path.module}/lambda-js"
  s3_artifact_bucket     = aws_s3_bucket.manifest_code.id
  plaintext_params = {
    MANIFEST_DOMAIN = aws_cloudfront_distribution.manifests.domain_name
  }
  timeout = 10
}

resource "random_id" "s3" {
  byte_length = 2
}

resource "aws_s3_bucket" "manifest_code" {
  provider = aws.us_east_1
  bucket   = "bccm-manifest-lambda-${var.env}-${random_id.s3.hex}"

  tags = {
    Environment = var.env
  }
}

resource "aws_s3_bucket_acl" "manifest_code" {
  provider = aws.us_east_1
  bucket   = aws_s3_bucket.manifest_code.id
  acl      = "private"
}
