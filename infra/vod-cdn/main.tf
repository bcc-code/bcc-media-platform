terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.24.0"
      configuration_aliases = [aws.us_east_1]
    }
  }
}

variable "basepath" {
  type = string
}

variable "env" {
  type = string
}

variable "mediapackage_url" {
  type = string
}

variable "download_s3_domain" {
  type = string
}

variable "download_az_domain" {
  type = string
}

variable "public_keys" {
  type = map(string)
}

variable "custom_domain" {
  type = string
}

variable "files_custom_domain" {
  type = string
}

variable "legacy_cdn_domain" {
  type = string
}

variable "custom_domain_legacy" {
  type = string
}
