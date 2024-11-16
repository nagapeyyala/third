variable "vpc_cidr" {
  description = "cidr to create vpc"
  type = string
}
variable "subnet01_cidr" {
  description = "a cidr block to create subnet"
  type = string
}
variable "subnet02_cidr" { 
  description = "a cidr block to create subent2"
  type = string 
}

variable "az_sub01" {
  description = "an az to create for subnet" 
  type = string
}
variable "az_sub02" { 
  description = "an az to create for subnet"
  type = string 
}
variable "aws_ami" {
  description = "an ami to create an instance"
  type = string
}
variable "aws_instance_type" {
  description = "an istance type to create an instance"
  type = string
}
variable "aws_keypair" {
  description = "a keypait to create an instance"
  type = string
}
variable "aws_region" {
  description = "a region to provision resources"
  type = string

}
 

 
