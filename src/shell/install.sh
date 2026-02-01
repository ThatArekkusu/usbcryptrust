cryptsetup_check=$(which cryptsetup)
if [$cryptsetup_check == ""];
then
    echo "cryptsetup not found, installing..."
    sudo pacman -S cryptsetup --noconfirm
fi

PC_USB_CONF=$PWD/pckey/gpg-pc.conf
USB_USB_CONF=$PWD/usbkey/gpg-usb.conf

ENV=$PWD/.env
source $ENV

sudo lsblk -f 
echo 

# USB_PATH="USER INPUT"
read -p "Enter the path of your usb device: " USB_PATH
sed -i '3d' "$ENV"

echo "USB_PATH=\"$USB_PATH\"" >> "$ENV"

sudo mkdir /mnt/encrypted_usb/
sudo mkdir pckey
sudo mkdir usbkey

LUKS_PASSPHRASE=$(tr -dc 'A-Za-z0-9!?%=' < /dev/urandom | head -c 10)
sed -i '4d' "$ENV"
echo "LUKS_PASSPHRASE=\"$LUKS_PASSPHRASE\"" >> "$ENV"

#printf '%s' "$LUKS_PASSPHRASE" | sudo cryptsetup luksFormat --type luks2 --key-file - "$USB_PATH"
#printf '%s' "$LUKS_PASSPHRASE" | sudo cryptsetup luksOpen --key-file - "$USB_PATH" encrypted_usb

sudo sed -i "4d" "$PC_USB_CONF"
sudo sed -i "5d" "$PC_USB_CONF"
sudo echo "Name-Real: $USER" >> "$PC_USB_CONF"
sudo echo "Name-Email: $USER@archlinux" >> "$PC_USB_CONF"

sudo sed -i "4d" "$USB_USB_CONF"
sudo sed -i "5d" "$USB_USB_CONF"
sudo echo "Name-Real: $USER" >> "$USB_USB_CONF"
sudo echo "Name-Email: $USER@usbkey" >> "$USB_USB_CONF"

#printf '%s' "$LUKS_PASSPHRASE" | sudo cryptsetup luksClose encrypted_usb