terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

variable "name" {
  type = string
}

variable "env" {
  type = string
}

variable "target" {
  type = string
}

resource "aws_cloudwatch_event_target" "target" {
  target_id = "${var.name}-${var.env}"
  rule      = aws_cloudwatch_event_rule.event-filter.name
  arn       = aws_sns_topic.default.arn
}

resource "aws_cloudwatch_event_rule" "event-filter" {
  name        = "${var.name}-${var.env}"
  description = "Capture all MediaPackage ingest events"

  event_pattern = <<PATTERN
{
  "source": ["aws.mediapackage"],
  "detail-type": ["MediaPackage Input Notification"]
}
PATTERN
}

// This should maybe be extracted to we can have one topic for multiple things
resource "aws_sns_topic" "default" {
  name = "${var.name}-${var.env}-eventbridge"

  // Copied from a sample, not tweaked yet.
  // https://docs.aws.amazon.com/sns/latest/dg/sns-message-delivery-retries.html
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 30,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

resource "aws_sns_topic_subscription" "default" {
  topic_arn = aws_sns_topic.default.arn
  protocol  = "https"
  endpoint  = var.target
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.default.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "eventbridge_to_sns_${var.name}_${var.env}"

  statement {
    actions = [
      "SNS:Publish",
    ]

    condition {
      test     = "ArnEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudwatch_event_rule.event-filter.arn
      ]
    }

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.default.arn,
    ]

    sid = "__default_statement_ID"
  }
}
