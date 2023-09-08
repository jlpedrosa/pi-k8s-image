

# Raspberry PI k8s image builder
This repository goal is to create an automatic system to generate Raspberry PI images with all required packages
to proceed to the installation of kubernetes.

It relies on packer and qemu to virtualize an ARM64 VM starting the ubuntu? (I am not sure if this works on PI 4) cloud images,
triggering the installation through cloud-init. If cloud init would not be enough to perform all the steps required, with packer custom 
scripts can be used as well as ansible.

This process completes correctly (after a long time ~5 mins), but the result has not been tested in a Pi4.


## Requirements


### Mac ?
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/packer qemu
```

### Ubuntu
Add package repository from [hashicorp instructions](https://developer.hashicorp.com/packer/downloads?product_intent=packer)

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt-get install packer qemu-system-aarch64 libnfs-utils open-iscsi jq
```

On the ubuntu server on arm64 through [qemu guide](https://wiki.ubuntu.com/ARM64/QEMU#:~:text=Ubuntu%2Farm64%20can%20run%20inside,you%20have%20an%20arm64%20host) they reference the firmware ?
`/usr/share/AAVMF/AAVMF_CODE.fd` and also creating a copy of it. I'm not positive what is this, but it seems to be working

so before running the packer build:
```bash
cp /usr/share/AAVMF/AAVMF_CODE.fd .
cp /usr/share/AAVMF/AAVMF_CODE.fd flash1.img
```

or `make copy-firmware`

## Creating the images 
```bash
PACKER_LOG=1 packer build .
```

or `make build`