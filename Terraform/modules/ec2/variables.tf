variable "ami" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "sg" {
  type = map(any)
}
variable "vpc_id" {
  type = string
}
variable "key_name" {
  type = string
}
variable "volume_size" {
  type = number
}