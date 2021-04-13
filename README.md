# nginx-website-ecs-cluster

This repository is designed to deploy an ECS cluster into an AWS account.

## Usage
1. Clone this repository for private use.

2. Setup your repository so that there is a webhook for CircleCI.

3. Set up your CircleCI pipeline so that these environment variables exist:

    | Variable                       | Description                                               |
    | ------------------------------ | --------------------------------------------------------- |
    | `AWS_ACCESS_KEY_ID`            | Used by the AWS CLI                                       |
    | `AWS_SECRET_ACCESS_KEY `       | Used by the AWS CLI                                       |

    All `AWS` variables must be created in the AWS console.
    - The IAM user attached to the pipeline will need relevent permissions to access, create and delete the resources defined.
    - It is assumed that the S3 bucket being written to already exists.


4. Edit certain variables for bespoke deployments:
    - Define the task definition in the `/templates/task-definition.json` file. User would need to change the image used.

    Optional:
    - The `terraform.tfvars` file. Contains most of the variables.
    - The `backend.tf` bucket value and region.

5. Generate a build. You can create/update all resources by changing the deploy flag to `deploy=0` in `terraform.tfvars`

6. The ECS cluster should be running in the AWS account. The final output from the build will be the ALB DNS address.

7. Once finished, you can destroy the ECS cluster and all resources by changing the deploy flag `deploy=0` in `terraform.tfvars`.