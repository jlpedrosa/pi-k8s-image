packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
    sshkey = {
      version = ">= 1.0.1"
      source  = "github.com/ivoronin/sshkey"
    }
  }
}


variable "iso_url_arm64" {
  default     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-arm64.img"
  description = "The url of the location of the cloud image for the operating system"
}

variable "iso_url_amd64" {
  default     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  description = "The url of the location of the cloud image for the operating system"
}

variable "iso_checksum" {
  default     = "file:https://cloud-images.ubuntu.com/jammy/current/SHA256SUMS"
  description = "file with the contents of the checksums of the OS"
}


variable "ssh_username" {
  default     = "packer"
  description = "the username that will be created by cloud init to execute packer"
}

variable "ssh_timeout" {
  default = "6h"
}
variable "output_directory" {
  default = "./packer-output"
  description = "Path where the final disk images are persisted"

}
variable "disk_size" {
  default = "5G"
  description = "The size of the resulting/output/generated disk"
}


variable "operator_username" {
  default = "jose"
  description = "the name of the additional user to be created to connect the instances"
}

variable "domain" {
  description = "the domain for the PIs created"
  default = "awsd.tech"
}

variable "operator_ssh_pub_key" {
  default = "/home/jose/.ssh/id_ed25519.pub"
  description = "ssh public key associated to the oprator user"
}

# this SSH is only created for packer so ti can connect to the VM and execute the provisioners
data "sshkey" "communicator" {
  name = var.ssh_username
  type = "rsa"
}

# Store in a variable the contents of the ssh public key so it can be added
# to cloud init users: as authorized keys.
locals {
  operator_ssh_pub_key = file(var.operator_ssh_pub_key)
}

# here we generate the json for cloud-init, so it performs all the configuration of the OS
# the contents of these variables are located in the files "cloud-init-*-pkr.hcl
locals {
    pi_vm_contents =  {
      user_data = jsonencode({
        ssh_pwauth      = true
        users           = local.users
        timezone        = "Europe/Dublin"
        bootcmd         = [
          "echo 'Raspberry Pi 4 Model B Rev 1.5' > /etc/flash-kernel/machine",
          "echo 'yes' > /etc/flash-kernel/ignore-efi",
          "mkdir /boot/firmware",

          # this terrible hack is to avoid checking if it's actually running on EFI (which we are in qemu)
          # in the next version this can be overriden by writing "yes" to /etc/flash-kernel/ignore-efi (as done in this script)
          # the version where it is fixed is https://sources.debian.org/src/flash-kernel/3.107/ (and uses ignore-efi)
          "sed  -i '1067,1072d' /usr/share/flash-kernel/functions"
        ]

        apt             = local.apt
        package_update  = true
        package_upgrade = false
        packages        = local.packages_arm64
        write_files     = local.write_files
        runcmd          = local.runcmd
      })
    }
    amd_64_contents =  {
    user_data = jsonencode({
      ssh_pwauth      = true
      users           = local.users
      timezone        = "Europe/Dublin"
      apt             = local.apt
      snap            = local.snap
      package_update  = true
      package_upgrade = false
      packages        = local.packages_amd64
      write_files     = local.write_files
      runcmd          = local.runcmd
    })
  }
}

# ARM vm, hopefully this will be close enough to a Raspberry pi.
#source "qemu" "ubuntu_pi" {
#  # configuration of the virtual hardware
#  net_device     = "virtio-net-pci"
#  disk_interface = "virtio"
#  machine_type   = "virt"
#  qemu_binary    = "qemu-system-aarch64"
#  accelerator    = "none"
#  memory         = 4096
#  cpus           = 8
#  cpu_model      = "cortex-a72"
#
#  headless            = false
#  use_default_display = true
#
#  ssh_username         = var.ssh_username
#  ssh_private_key_file = data.sshkey.communicator.private_key_path
#  ssh_timeout          = var.ssh_timeout
#
#  # Force vnc to 6000 so we can login easily for debugging
#  vnc_port_min = 6000
#  vnc_port_max = 6010
#  disable_vnc  = false
#
#  # Force ssh to 2222 so we can login easily for debugging
#  host_port_min = 2222
#  host_port_max = 2232
#
#  # Source disk configuration, use the ISO but as a disk so it can be written by cloud-init
#  # this disk will be also the result of the build
#  iso_url            = var.iso_url_arm64
#  iso_checksum       = var.iso_checksum
#  disk_image         = true
#  disk_size          = var.disk_size
#  disk_detect_zeroes = "on"
#
#  format           = "raw"
#  output_directory = var.output_directory
#
#  qemuargs = [
#    ["-pflash", "AAVMF_CODE.fd"],
#    ["-pflash", "flash1.img"],
#    ["-monitor", "none"],
#    ["-boot", "strict=off"]
#  ]
#
#  # shutdown the vm via software
#  shutdown_command = "sudo shutdown"
#}

# AMD64 hopefully this will be close enough to a Raspberry pi.
source "qemu" "ubuntu_amd64" {
  # configuration of the virtual hardware
  net_device     = "virtio-net-pci"
  disk_interface = "virtio"
  machine_type   = "ubuntu"
  qemu_binary    = "qemu-system-x86_64"
  accelerator    = "none"
  memory         = 4096
  cpus           = 8

  headless            = false
  use_default_display = true

  ssh_username         = var.ssh_username
  ssh_private_key_file = data.sshkey.communicator.private_key_path
  ssh_timeout          = var.ssh_timeout

  # Force vnc to 6000 so we can login easily for debugging
  vnc_port_min = 6000
  vnc_port_max = 6010
  disable_vnc  = false

  # Force ssh to 2222 so we can login easily for debugging
  host_port_min = 2222
  host_port_max = 2232

  # Source disk configuration, use the ISO but as a disk so it can be written by cloud-init
  # this disk will be also the result of the build
  iso_url            = var.iso_url_amd64
  iso_checksum       = var.iso_checksum
  disk_image         = true
  disk_size          = var.disk_size
  disk_detect_zeroes = "on"

  format           = "raw"
  output_directory = var.output_directory

  # shutdown the vm via software
  shutdown_command = "sudo shutdown"
}

#build {
#  source "qemu.ubuntu_pi" {
#    name    = "temp-packer-pi"
#    vm_name = "temp-packer-pi"
#    # cloud-init will get removable devices with "cidata" label, so we create a CD-ROM with
#    # user-data, meta-data.
#    cd_label = "cidata"
#    cd_content = {
#      "meta-data" = templatefile("meta-data", {})
#      "user-data" = format("#cloud-config\n%s", local.pi_vm_contents.user_data)
#      "config.txt" = templatefile("config.txt", {})
#    }
#  }
#
#  provisioner "shell" {
#    inline = [
#      "echo 'Waiting for cloud-init ....'; while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 5; done; echo 'Done'",
#    ]
#  }
#
#  provisioner "breakpoint" {
#    disable = true
#    note    = "this is a breakpoint"
#  }
#
#  provisioner "shell" {
#    inline = [
#      // uninstall non rapi kernels
#      "sudo DEBIAN_FRONTEND=noninteractive apt-get purge --assume-yes $(apt list --installed | grep -E 'virtual|generic' 2>/dev/null  | awk -F'/' '{printf(\"%s \",$1)} END { printf \"\\n\" }')",
#
#      // uninstall unused packages
#      "sudo DEBIAN_FRONTEND=noninteractive apt autoremove --purge && sudo apt-get upgrade",
#
#      //remove /etc/hostname so it picks it up via DHCP
#      "sudo rm /etc/hostname"
#    ]
#  }
#
#  #  provisioner "shell" {
#  #    inline = [
#  #      "sudo cloud-init clean",
#  #    ]
#  #  }
#}

build {

  source "qemu.ubuntu_amd64" {
    name    = "temp-packer-amd64"
    vm_name = "temp-packer-amd64"
    # cloud-init will get removable devices with "cidata" label, so we create a CD-ROM with
    # user-data, meta-data.
    cd_label = "cidata"
    cd_content = {
      "meta-data" = templatefile("meta-data", {})
      "user-data" = format("#cloud-config\n%s", local.amd_64_contents.user_data)
    }
  }

  provisioner "shell" {
    inline = [
      "echo 'Waiting for cloud-init ....'; while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 5; done; echo 'Done'",
    ]
  }

#   provisioner "shell" {
#     inline = [
#       // add igc module and regenerate initramfs so ISCI can connect.
#       # "sudo bash -c 'echo 'igc' >> /etc/initramfs-tools/modules'",
#       # "sudo apt-get install linux-image-generic",
#       //"sudo update-initramfs -u -v",
#     ]
#   }

  provisioner "shell" {
    inline = [
      // uninstall unused packages
      "sudo DEBIAN_FRONTEND=noninteractive apt autoremove --purge && sudo apt-get upgrade",

      //remove /etc/hostname so it picks it up via DHCP
      "sudo rm /etc/hostname"
    ]
  }

  provisioner "breakpoint" {
    disable = true
    note    = "this is a breakpoint"
  }

  #  provisioner "shell" {
  #    inline = [
  #      "sudo cloud-init clean",
  #    ]
  #  }
}