terraform {
  required_version = ">= 0.12.9"

  required_providers {
    aws        = ">= 5.13.0"
    local      = ">= 1.2"
    null       = ">= 2.1"
    template   = ">= 2.1"
    random     = ">= 2.1"
    kubernetes = ">= 1.6.2"
  }
}
