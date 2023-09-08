STORAGE_SERVER=10.40.10.100
ISCSI_TARGET_IP=$(STORAGE_SERVER):3260
ISCSI_TARGET_IQN=iqn.2004-04.com.qnap:tvs-882:iscsi.pi03.04a272
TEMP_DIR=$(shell mktemp -d)
PI_DISK=packer-output/pi03

.PHONY: build
build: packer-init packer-run

.PHONY: packer-run
packer-run:
	PACKER_LOG=1 packer build .

.PHONY: packer-init
packer-init:
	PACKER_LOG=1 packer init .

.PHONY: copy-vm-firmware
copy-vm-firmware:
	cp /usr/share/AAVMF/AAVMF_CODE.fd .
	cp /usr/share/AAVMF/AAVMF_CODE.fd flash1.img

.PHONY: connect-iscsi
connect-iscsi:
	sudo iscsiadm -m discovery -t st -p $(ISCSI_TARGET_IP)
	sudo iscsiadm -m node -T $(ISCSI_TARGET_IQN) -p $(ISCSI_TARGET_IP) -l
	sleep 2

.PHONY: disconnect-iscsi
disconnect-iscsi:
	sudo iscsiadm -m node -T $(ISCSI_TARGET_IQN) -p $(ISCSI_TARGET_IP) -u
	sudo iscsiadm -m node -o delete -T $(ISCSI_TARGET_IQN)

.PHONY: mount-generated-disk
mount-generated-disk:
	sudo losetup --partscan --find $(PI_DISK)
	sudo mount -t ext4 /dev/disk/by-label/cloudimg-rootfs  $(TEMP_DIR)

.PHONY: copy-pi-firmware
copy-pi-firmware:
	sudo scp -r /tmp/tmp.fAfFnGEnF4/boot/firmware/* jose@$(STORAGE_SERVER):/share/CACHEDEV2_DATA/tftproot/firmware

.PHONY: copy-boot-cfg
copy-boot-cfg:
	sudo scp ./config.txt jose@$(STORAGE_SERVER):/share/CACHEDEV2_DATA/tftproot/pi03custom
	ISCSI_TARGET_IQN=$(ISCSI_TARGET_IQN) ISCSI_TARGET_IP=$(STORAGE_SERVER) envsubst < cmdline.txt | ssh jose@10.40.10.100 "cat >/share/CACHEDEV2_DATA/tftproot/pi03custom/cmdline.txt"


.PHONY: write-pi-os-disk
write-pi-os-disk:
	sudo dd bs=4M if=$(PI_DISK) of=/dev/disk/by-path/ip-$(ISCSI_TARGET_IP)-iscsi-$(ISCSI_TARGET_IQN)-lun-0 status=progress && sync

# to be run tftp storage server.
.PHONY: write-pi-boot-disk
write-pi-boot-disk:
	mkdir firmware
	mkdir pi03custom
	mkdir pi03
	sudo mount -t overlay overlay -o lowerdir=firmware:pi03custom pi03

.PHONY:
auto-attempt: copy-vm-firmware packer-init build connect-iscsi write-pi-os-disk disconnect-iscsi mount-generated-disk

.PONY: multi
multi: PI_DISK=$(shell ls ./packer-output)
