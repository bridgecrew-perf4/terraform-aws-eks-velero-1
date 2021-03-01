variable "namespaces" {
  type = list(string)
}

variable "schedule" {
  type = string
}

variable "ttl" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "prefix" {
  type    = string
  default = ""
}

variable "velero_namespace" {
  type    = string
  default = "velero"
}

variable "account_id" {
  type = string
}

variable "oidc_host_path" {
  type = string
}

variable "region" {
  type = string
}