variable "region" {
  description = "AWS region"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
}

variable "zone_id" {
  description = "Route 53 Hosted Zone ID (optional)"
  type        = string
  default     = ""
}
