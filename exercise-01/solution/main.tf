terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Generate a random pet name
resource "random_pet" "server_name" {
  length    = 2
  separator = "-"
}

# Generate a random integer
resource "random_integer" "port" {
  min = 8000
  max = 8999
}

# Generate a random password
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Generate a random UUID
resource "random_uuid" "session_id" {
}

# Output the generated values
output "server_name" {
  value       = random_pet.server_name.id
  description = "Generated server name"
}

output "port" {
  value       = random_integer.port.result
  description = "Generated port number"
}

output "password" {
  value       = random_password.db_password.result
  description = "Generated password"
  sensitive   = true
}

output "session_id" {
  value       = random_uuid.session_id.result
  description = "Generated session UUID"
}
