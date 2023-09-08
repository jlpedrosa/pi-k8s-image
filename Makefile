ISCSI_TARGET_IP=10.40.10.100:3260
ISCSI_TARGET_IQN=iqn.2004-04.com.qnap:tvs-882:iscsi.pi3root.04a272

.PHONY: build
build:
	PACKER_LOG=1 packer build .

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
	sudo mount /tmp/fdimage /mnt -t vfat -o loop=/dev/loop3

.PHONY: write-pi-os-disk
write-pi-os-disk:
	ls /dev/disk/by-path/ip-$(ISCSI_TARGET_IP)-$(ISCSI_TARGET_IQN)-lun-0
	#sudo dd bs=4M if=./packer-output/arm64-ubuntu of=/dev/sda status=progress && sync

