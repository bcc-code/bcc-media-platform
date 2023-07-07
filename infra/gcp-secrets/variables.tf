variable "secrets" {
  type = map(any)
}

variable "project" {
  type = string
}

variable "secret_accessors" {
  type = list(string)
}
