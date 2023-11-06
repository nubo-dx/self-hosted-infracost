variable "infracost_api_key" {
  type        = string
  default     = ""
  description = "Infracost API key"
}

variable "infracost_self_hosted_api_key" {
  type        = string
  default     = ""
  description = "Infracost self-hosted API key"
}

variable "administrator_login" {
  type        = string
  default     = "psqladmin"
  description = "The administrator username of the PostgreSQL server."
}

variable "administrator_password" {
  type        = string
  default     = "mypasswordjsp123!"
  description = "The administrator password of the PostgreSQL server."
}