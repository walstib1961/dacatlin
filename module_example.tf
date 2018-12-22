variable "ami" {}
variable "subnet_id" {}
variable "vpc_security_group_id" {}
variable "identity" {}

variable "key_name" {}
variable "private_key" {}
variable "num_webs" {
default = "2"
}

resource "aws_instance" "web" {
count = "${var.num_webs}"
  ami                    = "${var.ami}"
  instance_type          = "t2.nano"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${var.vpc_security_group_id}"]
  key_name               = "${var.key_name}"

connection {
user = "ubuntu"
private_key = "${var.private_key}"
}

provisioner "file" {
source = "assets"
destination = "/tmp/"
}

provisioner "remote-exec" {
inline = [
"sudo sh /tmp/assets/setup-web.sh",
]
}
  tags {
    "Identity"    = "${var.identity}"
"Name" = "Student ${count.index+1}/${var.num_webs}"
    "Environment" = "Training"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}
