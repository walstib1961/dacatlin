variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "us-east-1"
}

variable "ami" {}
variable "subnet_id" {}
variable "identity" {}
variable "vpc_security_group_id" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "keypair" {
  source = "mitchellh/dynamic-keys/aws"
path   = "${path.root}/keys"
  name   = "${var.identity}-key"
}

module "server" {
  source                = "./server"
  ami                   = "${var.ami}"
  subnet_id             = "${var.subnet_id}"
  vpc_security_group_id = "${var.vpc_security_group_id}"
  identity              = "${var.identity}"
  key_name              = "${module.keypair.key_name}"
  private_key           = "${module.keypair.private_key_pem}"
}

output "public_ip" {
  value = "${module.server.public_ip}"
}

output "public_dns" {
  value = "${module.server.public_dns}"
}
