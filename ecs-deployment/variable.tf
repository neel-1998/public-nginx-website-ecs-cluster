variable "availability_zones" {
  type    = list(string)
  default = []
}

variable "cluster_name" {
  type    = string
  default = "test-ecs-cluster"
}

variable "public_subnets" {
  type    = list(string)
  default = []
}

variable "vpc_cidr_block" {
  type    = string
  default = ""
}