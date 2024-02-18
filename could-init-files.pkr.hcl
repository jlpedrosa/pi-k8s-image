
locals {
  write_files = [
    {
      path        = "/etc/sysctl.d/10-ip-forwarding.conf"
      permissions = "0644"
      content     = "net.ipv4.conf.all.forwarding=1"
    },
  ]
}