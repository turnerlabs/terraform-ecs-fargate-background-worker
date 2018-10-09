# Environment Dev Terraform

Creates the dev environment's infrastructure. These templates are designed to be customized.  
The optional components can be removed by simply deleting the `.tf` file.


## Components

| Name | Description | Optional |
|------|-------------|:----:|
| [main.tf][edm] | Terrform remote state, AWS provider, output |  |
| [ecs.tf][ede] | ECS Cluster, Service, Task Definition, ecsTaskExecutionRole, CloudWatch Log Group |  |
| [nsg.tf][edn] | NSG for ALB and Task |  |
| [dashboard.tf][edd] | CloudWatch dashboard: CPU, memory, and HTTP-related metrics | Yes |
| [role.tf][edr] | Application Role for container | Yes |
| [cicd.tf][edc] | IAM user that can be used by CI/CD systems | Yes |
| [autoscale-perf.tf][edap] | Performance-based auto scaling | Yes |
| [autoscale-time.tf][edat] | Time-based auto scaling | Yes |
| [logs-logzio.tf][edll] | Ship container logs to logz.io | Yes |
| [secretsmanager.tf][sm] | Provision a Secrets Manager secret for your app | Yes |


## Usage

```
# Sets up Terraform to run
$ terraform init

# Executes the Terraform run
$ terraform apply
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app | The application's name | string | - | yes |
| aws_profile | The AWS Profile to use | string | - | yes |
| container_name | The name of the container to run | string | `app` | no |
| default_backend_image | The default docker image to deploy with the infrastructure. Note that you can use the fargate CLI for application concerns like deploying actual application images and environment variables on top of the infrastructure provisioned by this template https://github.com/turnerlabs/fargate note that the source for the turner default backend image is here: https://github.com/turnerlabs/turner-defaultbackend | string | `quay.io/turner/turner-defaultbackend:0.2.0` | no |
| ecs_as_cpu_high_threshold_per | If the average CPU utilization over a minute rises to this threshold, the number of containers will be increased (but not above ecs_autoscale_max_instances). | string | `80` | no |
| ecs_as_cpu_low_threshold_per | If the average CPU utilization over a minute drops to this threshold, the number of containers will be reduced (but not below ecs_autoscale_min_instances). | string | `20` | no |
| ecs_autoscale_max_instances | The maximum number of containers that should be running. | string | `8` | no |
| ecs_autoscale_min_instances | The minimum number of containers that should be running. Must be at least 1. For production, consider using at least "2". | string | `1` | no |
| environment | The environment that is being built | string | - | yes |
| logz_token | The auth token to use for sending logs to Logz.io | string | - | yes |
| logz_url | The endpoint to use for sending logs to Logz.io | string | `https://listener.logz.io:8071` | no |
| private_subnets | The private subnets, minimum of 2, that are a part of the VPC(s) | string | - | yes |
| public_subnets | The public subnets, minimum of 2, that are a part of the VPC(s) | string | - | yes |
| region | The AWS region to use for the dev environment's infrastructure Currently, Fargate is only available in `us-east-1`. | string | `us-east-1` | no |
| replicas | How many containers to run | string | `1` | no |
| saml_role | The SAML role to use for adding users to the ECR policy | string | - | yes |
| scale_down_cron | Default scale down at 7 pm every day | string | `cron(0 23 * * ? *)` | no |
| scale_down_max_capacity | The maximum number of containers to scale down to. | string | `0` | no |
| scale_down_min_capacity | The mimimum number of containers to scale down to. Set this and `scale_down_max_capacity` to 0 to turn off service on the `scale_down_cron` schedule. | string | `0` | no |
| scale_up_cron | Default scale up at 7 am weekdays, this is UTC so it doesn't adjust to daylight savings https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html | string | `cron(0 11 ? * MON-FRI *)` | no |
| secrets_saml_users | The users (email addresses) from the saml role to give access | list | - | yes |
| tags | Tags for the infrastructure | map | - | yes |
| vpc | The VPC to use for the Fargate cluster | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws_profile | Command to set the AWS_PROFILE |
| cicd_keys | The AWS keys for the CICD user to use in a build system |
| deploy | Command to deploy a new task definition to the service using Docker Compose |
| docker_registry | The URL for the docker image repo in ECR |
| scale_out | Command to scale out the number of tasks (container replicas) |
| scale_up | Command to scale up cpu and memory |
| status | Command to view the status of the Fargate service |



[edm]: main.tf
[ede]: ecs.tf
[edn]: nsg.tf
[edd]: dashboard.tf
[edr]: role.tf
[edc]: cicd.tf
[edap]: autoscale-perf.tf
[edat]: autoscale-time.tf
[edll]: logs-logzio.tf
[sm]: ./env/dev/secretsmanager.tf
[alb-docs]: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html
[up]: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html
