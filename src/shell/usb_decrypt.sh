#!/bin/bash

#Temp decrypt script imported from USBCRYPTGO

DEVICE=""
MAPPER_NAME="encrypted_usb"
MOUNT_POINT="/mnt/encrypted_usb"

if [ -z "$LUKS_PASSPHRASE" ]; then
    echo "LUKS_PASSPHRASE not set!"
    exit 1
fi

echo "$LUKS_PASSPHRASE" | sudo -S cryptsetup open "$DEVICE" "$MAPPER_NAME"
sudo mount "/dev/mapper/$MAPPER_NAME" "$MOUNT_POINT"