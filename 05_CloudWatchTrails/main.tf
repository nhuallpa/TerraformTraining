provider "aws" {
    region = "us-east-1"
}

resource "aws_sns_topic" "alarm_sns_topic" {
  name = "alarm-updates-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_sns_topic.arn
  protocol  = "email"
  endpoint  = "nestor.huallpa@gmail.com"
}


resource "aws_s3_bucket" "trail_backet" {
    bucket = "cloudwatch-trail-backet-log-1234567890"
    acl    = "private"
}

resource "aws_s3_bucket_policy" "trail_bucket_policy" {
    bucket = aws_s3_bucket.trail_backet.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "cloudtrail.amazonaws.com"
                }
                Action = "s3:GetBucketAcl"
                Resource = "${aws_s3_bucket.trail_backet.arn}"
            },
            {
                Effect = "Allow"
                Principal = {
                    Service = "cloudtrail.amazonaws.com"
                }
                Action = "s3:PutObject"
                Resource = "${aws_s3_bucket.trail_backet.arn}/*"
                Condition = {
                    StringEquals = {
                        "s3:x-amz-acl" = "bucket-owner-full-control"
                    }
                }
            }
        ]
    })
}

resource "aws_cloudtrail" "cloudtrail" {
    name                          = "cloudtrail-trail"
    s3_bucket_name                 = aws_s3_bucket.trail_backet.bucket
    include_global_service_events  = true
    is_multi_region_trail         = true
    enable_log_file_validation    = true
}

resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
    name = "/aws/cloudtrail/my-logs"
    retention_in_days = 7
}

resource "aws_cloudwatch_log_metric_filter" "cloudtrail_error" {
    name = "cloudtrail-metric-filter"
    log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
    pattern = "{ $.errorCode = \"*UnauthorizedOperation\" || $.errorCode = \"AccessDenied*\" }"

    metric_transformation {
        name = "UnauthorizedOperationErrors"
        namespace = "CloudTrailMetrics"
        value = "1"
    }
}

resource "aws_cloudwatch_metric_alarm" "cloudtrail_alarm" {
    alarm_name = "cloudtrail-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = 1
    metric_name = aws_cloudwatch_log_metric_filter.cloudtrail_error.metric_transformation[0].name
    namespace = aws_cloudwatch_log_metric_filter.cloudtrail_error.metric_transformation[0].namespace
    period = 300
    statistic = "Sum"
    threshold = 1

    alarm_actions = [
        "${aws_sns_topic.alarm_sns_topic.arn}"
    ]
}