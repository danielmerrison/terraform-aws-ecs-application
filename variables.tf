variable "application_name" {
  type        = string
  description = "Name of the application.  The application name is an overarching name of a collection of ecs services."
}

# I am expecting this to be needed so commenting out for now
# variable "vpc_id" {
#   type        = string
#   description = "ID of the vpc used by the ECS application"
# }

# I am expecting this to be needed so commenting out for now
variable "private_subnet_ids" {
  type        = list(string)
  description = "IDs of the private subnets"
}

# I am expecting this to be needed so commenting out for now
# variable "public_subnet_ids" {
#   type        = list(string)
#   description = "IDs of the public subnets"
# }
