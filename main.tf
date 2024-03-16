
variable "storage_ip" {
  description = "The ip address of the storage server"
}

variable "storage_ssh_user" {
  description = "Username to connect to the remote server"
}

 variable "storage_ssh_private_key_path" {
 description = "Path for the key of the user to connect to the remote server"
 }

variable "root_tftp_folder" {
  description = "the folder in the remote server that is the root of the tftp server"
}

variable "source_images_folder" {
  description = "the folder in the remote server that is the root of the tftp server"
}

variable "pis" {
  description = "dictionary with the PIs, keys are pi name"
  # //
  #  "pi01" : {
  #    "serial": "serial",
  #   "mac_addr": "mac"
  # },
}

locals {
  any_pi= element(keys(var.pis),1)
}

locals {
  storage_ssh_private_key = file(var.storage_ssh_private_key_path)
}

resource "null_resource" "discover_iscsi_targets" {
  provisioner "local-exec" {
    command = "sudo iscsiadm -m discovery -t st -p ${var.storage_ip}"
  }
}

resource "null_resource" "connect_discs" {
  for_each = var.pis
  provisioner "local-exec" {
    command = "sudo iscsiadm -m node -T iqn.2004-04.com.qnap:tvs-882:iscsi.${each.key}.04a272 -p ${var.storage_ip} -l; sleep 5"
  }
  depends_on = [
    null_resource.discover_iscsi_targets
  ]
}

locals {
  temp_dir = "/tmp/mounted"
}

resource "null_resource" "copy_firmware" {
  connection {
    type = "ssh"
    host = var.storage_ip
    user = var.storage_ssh_user
    private_key = local.storage_ssh_private_key
    timeout = "20s"
  }

  provisioner "local-exec" {
    command = <<EOF
      mkdir ${local.temp_dir}
      sudo losetup --partscan --find ${var.source_images_folder}/${local.any_pi}
      sync
      sleep 10
      sudo mount -t ext4 /dev/disk/by-label/cloudimg-rootfs ${local.temp_dir}
    EOF
  }

  provisioner "file" {
    destination    = var.root_tftp_folder
    source         = "${local.temp_dir}/boot/firmware"
  }

  provisioner "file" {
    destination    = "${var.root_tftp_folder}/firmware/config.txt"
    source         = "config.txt"
  }
}

resource "null_resource" "render_bootcmd" {
  for_each = var.pis
  connection {
    type = "ssh"
    host = var.storage_ip
    user = var.storage_ssh_user
    private_key = local.storage_ssh_private_key
    timeout = "20s"
  }

  provisioner "file" {
    destination    = "${var.root_tftp_folder}/${each.key}/cmdline.txt"
    content        = "console=serial0,115200 dwc_otg.lpm_enable=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory console=tty1 root=/dev/sda1 rootfstype=ext4 ISCSI_INITIATOR=iqn.2019-09.us.tswn.us:${each.key} ISCSI_TARGET_NAME=iqn.2004-04.com.qnap:tvs-882:iscsi.${each.key}.04a272 ISCSI_TARGET_IP=${var.storage_ip} rootwait fixrtc nosplash"
  }
}

resource "null_resource" "prepare_pi_boot_filesystem" {
  for_each = var.pis
  connection {
    type = "ssh"
    host = var.storage_ip
    user = var.storage_ssh_user
    private_key = local.storage_ssh_private_key
    timeout = "20s"
  }

  provisioner "remote-exec" {
    inline = [
      "echo hola",
#      "mkdir ${var.root_tftp_folder}/${each.key} ${var.root_tftp_folder}/${each.value.serial}",
      "sudo mount -t overlay overlay -o lowerdir=${var.root_tftp_folder}/firmware:${var.root_tftp_folder}/${each.key} ${var.root_tftp_folder}/${each.value.serial}"
    ]
  }

  depends_on = [
    null_resource.render_bootcmd,
    null_resource.copy_firmware
  ]
}



resource "null_resource" "transfer_root_volumes" {
  for_each = var.pis

  provisioner  "local-exec" {
    command = <<-EOT
      sudo dd bs=4M if=${var.source_images_folder}/${each.key} of=/dev/disk/by-path/ip-${var.storage_ip}:3260-iscsi-iqn.2004-04.com.qnap:tvs-882:iscsi.${each.key}.04a272-lun-0 status=progress &&
      sudo sync  
    EOT    
  }

  depends_on = [
    null_resource.connect_discs
  ]
}

resource "null_resource" "disconnect_resources" {
  provisioner  "local-exec" {
    command = "sudo iscsiadm -m session -u ; sudo iscsiadm -m node --op delete; sudo umount ${local.temp_dir}; rm -rf ${local.temp_dir}"
  }

  depends_on = [
    null_resource.prepare_pi_boot_filesystem,
    null_resource.transfer_root_volumes,
    null_resource.render_bootcmd
  ]
}