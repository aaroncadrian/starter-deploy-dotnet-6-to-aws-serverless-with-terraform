variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "app_name" {
  type        = string
  description = "The name of your application"
  default     = "weather-forecast"
}

variable "environment_name" {
  type        = string
  description = "The name of your deployment environment, such as `dev` or `prod`"
  default     = "poc"
}

variable "dotnet_project_name" {
  type    = string
  default = "WebApplication1"
}