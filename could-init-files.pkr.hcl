
locals {
  write_files = [
    {
      path        = "/etc/sysctl.d/10-ip-forwarding.conf"
      permissions = "0644"
      content     = "net.ipv4.conf.all.forwarding=1"
    },
    {
     path = "/etc/multipath.conf"
     permisisons = "0644"
     content  =  <<EOF
      defaults {
        user_friendly_names yes
        find_multipaths yes
      }
      EOF
    }
  ]
}