variable "storage_ip" {
  description = "The ip address of the storage server"
  default = "10.40.10.100"
}

variable "storage_ssh_user" {
  description = "Username to connect to the remote server"
  default = "jose"
}

variable "storage_ssh_private_key_path" {
  description = "Username to connect to the remote server"
  default = "~/.ssh/id_rsa"
}

locals {
  storage_ssh_private_key = file(var.storage_ssh_private_key_path)
  storage_connection =  {
    type = "ssh"
    host = var.storage_ip
    user = var.storage_ssh_user
    private_key = local.storage_ssh_private_key
    timeout = "20s"
  }
}

resource "null_resource" "test" {

  connection  {
    type = "ssh"
    host = var.storage_ip
    user = var.storage_ssh_user
    private_key = local.storage_ssh_private_key
    timeout = "20s"
  }

  provisioner "remote-exec" {
    inline = ["echo 'remote-exec message'"]
  }
  provisioner "local-exec" {
    command = "echo 'local-exec message'"
  }
}