
locals {
  write_files = [
    {
      path        = "/etc/sysctl.d/10-ip-forwarding.conf"
      permissions = "0644"
      content     = "net.ipv4.conf.all.forwarding=1"
    },
    {
      path        = "/etc/sysctl.d/99-kubernetes-cri.conf"
      permissions = "0644"
      content     = <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
    },
  ]
}