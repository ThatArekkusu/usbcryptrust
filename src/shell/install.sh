#!/bin/bash

sudo mkdir /mnt/encrypted_usb/
sudo mkdir $PWD/src/pckey
sudo mkdir $PWD/src/usbkey
sudo cp $PWD/gpg-gen.conf.example $PWD/src/pckey/gpg-pc.conf
sudo cp $PWD/gpg-gen.conf.example $PWD/src/usbkey/gpg-usb.conf 
sudo cp $PWD/example.env $PWD/.env
sudo chmod 777 $PWD/scr/pckey/*
sudo chmod 777 $PWD/src/usbkey/*

cryptsetup_check=$(which cryptsetup)
if [$cryptsetup_check == ""];
then
    echo "cryptsetup not found, installing..."
    sudo pacman -S cryptsetup --noconfirm
fi

gnupg_check=$(which gnupg)
if [$gnupg_check == ""];
then
    echo "gnupg not found, installing..."
    sudo pacman -S gnupg --noconfirm
fi
sudo chown -R "$USER:$USER" "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg/openpgp-revocs.d" "$HOME/.gnupg/private-keys-v1.d" 2>/dev/null || true

PC_CONF=$PWD/src/pckey/gpg-pc.conf
PCKEY=$PWD/src/pckey/
USB_CONF=$PWD/src/usbkey/gpg-usb.conf
USBKEY=$PWD/src/usbkey/
ENV=$PWD/.env

LUKS_PASSPHRASE=$(tr -dc 'A-Za-z0-9!?%=' < /dev/urandom | head -c 10)

sudo lsblk -f 
echo

read -p "Enter the path of your usb device: " USB_PATH

sed -i "s|USB_PATH=''|USB_PATH='$USB_PATH'|g" $ENV
sed -i "s|LUKS_PASSPHRASE=''|LUKS_PASSPHRASE='$LUKS_PASSPHRASE'|g" $ENV
sed -i "s|Name-Real: YOUR NAME|Name-Real: $USER|g" $PC_CONF
sed -i "s|Name-Real: YOUR NAME|Name-Real: $USER|g" $USB_CONF
sed -i "s|Name-Email: YOUR EMAIL@example.com|Name-Email: $USER@PCKEY.com|g" $PC_CONF
sed -i "s|Name-Email: YOUR EMAIL@example.com|Name-Email: $USER@USBKEY.com|g" $USB_CONF

printf '%s' "$LUKS_PASSPHRASE" | sudo cryptsetup luksFormat --type luks2 --key-file - "$USB_PATH"
printf '%s' "$LUKS_PASSPHRASE" | sudo cryptsetup luksOpen --key-file - "$USB_PATH" encrypted_usb
sudo mkfs.ext4 /dev/mapper/encrypted_usb
sudo mount /dev/mapper/encrypted_usb /mnt/encrypted_usb
sudo cp $PWD/temp /mnt/encrypted_usb
ls /mnt/encrypted_usb

gpg --batch --gen-key $PC_CONF
gpg --batch --gen-key $USB_CONF
gpg --export --armor $USER@PCKEY.com > $PCKEY/pckey-public.asc
gpg --export --armor $USER@USBKEY.com > $USBKEY/usbkey-public.asc 
gpg --export-secret-keys --armor $USER@PCKEY.com > $PCKEY/pckey-private.asc
gpg --export-secret-keys --armor $USER@USBKEY.com > /mnt/encrypted_usb/pckey-private.asc

sudo umount /mnt/encrypted_usb 2>/dev/null || true

printf '%s' "$LUKS_PASSPHRASE" | sudo cryptsetup luksClose encrypted_usb