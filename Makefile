

.PHONY: build
build:
	PACKER_LOG=1 packer build .

.PHONY: copy-firmware
copy-firmware:
	cp /usr/share/AAVMF/AAVMF_CODE.fd .
	cp /usr/share/AAVMF/AAVMF_CODE.fd flash1.img