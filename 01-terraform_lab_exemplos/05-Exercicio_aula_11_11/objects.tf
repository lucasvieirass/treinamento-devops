variable "security_group"{
  type        = string
  description = "Informe o security group desejado:"

  validation {
    condition     = length(var.security_group) > 3 && substr(var.image_id, 0, 3) == "sg-"
    error_message = "O valor do image_id não é válido, tem que começar com \"ami-\"."
  }
}

output "image_id" {
    value = var.image_id
}