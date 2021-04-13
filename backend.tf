terraform {
  backend "s3" {
    bucket = "ecs-nginx-web"
    key    = "state/terraform.tfstate"
    region = "eu-west-2"
  }
}
