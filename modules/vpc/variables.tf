variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type        = map(string)
  description = "Map of AZ to public subnet cidr"
  default = {
    "eu-central-1a" : "10.0.0.0/24"
    "eu-central-1b" : "10.0.1.0/24"
    "eu-central-1c" : "10.0.2.0/24"
  }
}

variable "private_subnets" {
  type        = map(string)
  description = "Map of AZ to private subnet cidr"
  default = {
    "eu-central-1a" : "10.0.100.0/24"
    "eu-central-1b" : "10.0.101.0/24"
    "eu-central-1c" : "10.0.102.0/24"
  }
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Flag specifying public access"
  default     = true
}

variable "enable_vpn_gateway" {
  type        = bool
  description = "Flag specifying vpn access"
  default     = false
}
