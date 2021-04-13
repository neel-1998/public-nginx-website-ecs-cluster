variable "availability_zones" {
  type    = list(string)
  default = []
}

variable "cluster_name" {
  type    = string
  default = "test-ecs-cluster"
}

variable "deploy" {
  type    = number
  default = 1
}

variable "public_subnets" {
  type    = list(string)
  default = []
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "vpc_cidr_block" {
  type    = string
  default = ""
}