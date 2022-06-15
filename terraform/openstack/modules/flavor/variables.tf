variable "enabled" {
  type        = string
  default     = "1"
}

variable "flavor_definitions" {
  type        = list(map(any))
  default = [
    {
      name = "t2.micro"
      ram  = "1024"
      vcpu = "1"
      disk = "10"
    }
  ]
}
