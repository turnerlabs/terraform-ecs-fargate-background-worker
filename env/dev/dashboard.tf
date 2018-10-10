/**
 * This module creates a CloudWatch dashboard for you app,
 * showing its CPU and memory utilization.
 */

resource "aws_cloudwatch_dashboard" "cloudwatch_dashboard" {
  dashboard_name = "${var.app}-${var.environment}-fargate"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "view": "timeSeries",
        "stacked": false,
        "metrics": [
          [
            "AWS/ECS",
            "MemoryUtilization",
            "ServiceName",
            "${var.app}-${var.environment}",
            "ClusterName",
            "${var.app}-${var.environment}",
            {
              "color": "#1f77b4"
            }
          ],
          [
            ".",
            "CPUUtilization",
            ".",
            ".",
            ".",
            ".",
            {
              "color": "#9467bd"
            }
          ]
        ],
        "region": "${var.region}",
        "period": 300,
        "title": "Memory and CPU utilization",
        "yAxis": {
          "left": {
            "min": 0,
            "max": 100
          }
        }
      }
    }
  ]
}
EOF
}
