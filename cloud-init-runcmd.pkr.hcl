locals {
  runcmd = [
    ["systemctl", "enable", "crio"],
    ["systemctl", "start", "crio"],
    ["helm", "repo", "add", "cilium", "https://helm.cilium.io/"],
    ["kubeadm", "config", "images", "pull", "--kubernetes-version", var.kube_version],
  ]
}