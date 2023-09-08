ISCSI_TARGET_IP=10.40.10.100:3260
ISCSI_TARGET_IQN=iqn.2004-04.com.qnap:tvs-882:iscsi.pi3root.04a272
TEMP_DIR=$(shell mktemp -d)

.PHONY: build
build: packer-init packer-run

.PHONY: packer-run
packer-run:
	PACKER_LOG=1 packer build .

.PHONY: packer-init
packer-init:
	PACKER_LOG=1 packer init .

.PHONY: copy-firmware
copy-firmware:
	cp /usr/share/AAVMF/AAVMF_CODE.fd .
	cp /usr/share/AAVMF/AAVMF_CODE.fd flash1.img

.PHONY: connect-iscsi
connect-iscsi:
	sudo iscsiadm -m discovery -t st -p $(ISCSI_TARGET_IP)
	sudo iscsiadm -m node -T $(ISCSI_TARGET_IQN) -p $(ISCSI_TARGET_IP) -l

.PHONY: disconnect-iscsi
disconnect-iscsi:
	sudo iscsiadm -m node -T $(ISCSI_TARGET_IQN) -p $(ISCSI_TARGET_IP) -u
	sudo iscsiadm -m node -o delete -T $(ISCSI_TARGET_IQN)

.PONY: mount-generated-disk
mount-generated-disk:
	sudo mount -t ext4 /dev/disk/by-label/cloudimg-rootfs $(TEMP_DIR)

.PHONY: write-pi-os-disk
write-pi-os-disk:
	sudo dd bs=4M if=packer-output/arm64 of=/dev/disk/by-path/ip-$(ISCSI_TARGET_IP)-iscsi-$(ISCSI_TARGET_IQN)-lun-0 status=progress && sync

.PHONY:mount-firmware
mount-firmware:
	# $$(losetup  --json --list  -j packer-output/arm64-ubuntu | jq -r '.loopdevices[].name')
	sudo losetup -Pf packer-output/arm64-ubuntu

# to be run tftp storage server.
.PHONY: write-pi-boot-disk
write-pi-boot-disk:
	mkdir firmware
	mkdir pi3custom
	mkdir pi3
	sudo mount -t overlay overlay -o lowerdir=firmware:pi3custom p3

.PHONY:
auto-attempt: copy-firmware build connect-iscsi write-pi-os-disk disconnect-iscsi mount-generated-disk
