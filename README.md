

# Raspberry PI k8s image builder
This repository goal is to create an automatic system to generate Raspberry PI images with all required packages
to proceed to the installation of kubernetes.

It relies on packer and qemu to virtualize an ARM64 VM starting the ubuntu cloud images,
triggering the installation through cloud-init. There are some additional steps

This process completes correctly (after a long time ~100 mins in a Threadripper gen1), but the PIs boot correctly.
Deployment is "crude" to say the least, uses terraform to execute a bunch of scripts (yikes!) and also it depends
heavily on the hability to ssh in the iscsi and tftp server (the same box in my case, a qnap). It also requires terraform to
be run as root as the 

* Fix FSTAB on packer (P0)
* Make overlays mounts in Qnap persistent (P0)
* Fix hostname in packer for the machines. (or multi staged builds P0)
* Customize the meta-data in packer (P0)
* Understand what is cloud-init doing on the destination machines, if it already run correctly. Disable all other providers (P1)
* Need to do multistaged builds so it can build only 1 image (P2)
* Trying packer native in the raspberry itself, it may be faster (P2)
* Disable automatic eeprom updates (P2)
* Make the list of PIs configurable and passed to packer and terraform (P3)
* How the hell replace terraform (P3)
* Get notification when new versions are available (P3)
* Try to get packer to run direcly the kernel, so we can ditch the whole efi firmware and maybe we can start with the PI image directly. (P1)

## Requirements
A lot of patience, an x86_64 linux box, a lot of packages. 

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
OR
make build
```
To deploy:
```bash
terraform init; sudo terraform apply 
```


