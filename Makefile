TERRAFORM=/home/jose/.tfenv/bin/terraform

.PHONY: build
build: copy-vm-firmware packer-init packer-run

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

.PHONY: init
init:
	rm -rf terraform.state terraform.state.backup .terrafom .terraform.lock.hcl && $(TERRAFORM) init -var-file=$(VAR_FILE)

.PHONY: apply
apply: init
	 $(TERRAFORM) apply -var-file=$(VAR_FILE)




