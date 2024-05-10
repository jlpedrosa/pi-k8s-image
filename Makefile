TERRAFORM=/home/jose/.tfenv/bin/terraform

.PHONY: build
build: clean copy-vm-firmware packer-init packer-run

.PHONY: packer-run
packer-run:
	PACKER_LOG=1 packer build -var-file=$(VAR_FILE) .

.PHONY: packer-init
packer-init:
	PACKER_LOG=1 packer init .

.PHONY: copy-vm-firmware
copy-vm-firmware:
	cp /usr/share/AAVMF/AAVMF_CODE.fd .
	cp /usr/share/AAVMF/AAVMF_CODE.fd flash1.img

.PHONY: clean
clean:
	rm -rf packer-output





