variable "alert_name_prefix" {
  type = string
  default = ""
  description = "String to prefix CloudWatch alerts with to avoid naming collisions"
}

variable "cpu_threshold" {
  type = string
  default = 90
  description = "cpu percentage threshold for the alerts"
}

variable "memory_threshold" {
  type = string
  default = 90
  description = "memory percentage threshold for the alerts"
}