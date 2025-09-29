# install-nixos-laptop.sh
#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/ВАШ_ЮЗЕР/ВАШ_РЕПО.git"  # Замените на ваш repo
CONFIG_DIR="/tmp/nixos-config"
TARGET_DISK="nvme0n1"

echo "🚀 NixOS Laptop Auto-Installer"
echo "================================"

cleanup() {
    echo "🧹 Cleaning up..."
    rm -rf "$CONFIG_DIR"
}
trap cleanup EXIT

if [[ ! -f /etc/NIXOS ]]; then
    echo "❌ Error: This must be run from NixOS live ISO"
    exit 1
fi

echo "📡 Checking internet connection..."
if ! ping -c 1 google.com &>/dev/null; then
    echo "⚠️  No internet connection. Please connect first:"
    echo "   sudo systemctl start NetworkManager"
    echo "   nmcli device wifi list"
    echo "   nmcli device wifi connect 'SSID' password 'PASSWORD'"
    exit 1
fi

echo "💾 Available disks:"
lsblk -d -o NAME,SIZE,MODEL,TYPE | grep disk
echo
read -p "🎯 Enter target disk name (e.g., nvme0n1, sda): " TARGET_DISK

if [[ ! -b "/dev/$TARGET_DISK" ]]; then
    echo "❌ Error: Disk /dev/$TARGET_DISK not found"
    exit 1
fi

echo "⚠️  WARNING: This will COMPLETELY ERASE /dev/$TARGET_DISK"
echo "   All data will be lost permanently!"
read -p "Type 'DELETE_ALL_DATA' to continue: " CONFIRM

if [[ "$CONFIRM" != "DELETE_ALL_DATA" ]]; then
    echo "❌ Installation cancelled"
    exit 1
fi

echo "📥 Downloading NixOS configuration..."
git clone "$REPO_URL" "$CONFIG_DIR"
cd "$CONFIG_DIR"

echo "⚙️  Updating disk configuration..."
sed -i "s|device = \"/dev/nvme0n1\"|device = \"/dev/$TARGET_DISK\"|g" hosts/laptop/disko.nix

echo "🔧 Partitioning disk with disko..."
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko hosts/laptop/disko.nix

echo "📋 Copying configuration to /mnt..."
sudo mkdir -p /mnt/etc/nixos
sudo cp -r "$CONFIG_DIR"/* /mnt/etc/nixos/
cd /mnt/etc/nixos

echo "🔍 Generating hardware configuration..."
sudo nixos-generate-config --root /mnt --dir /mnt/etc/nixos/hosts/laptop/

echo "📦 Installing NixOS (this may take a while)..."
sudo nixos-install --flake .#laptop --no-root-passwd

echo "✅ Installation completed successfully!"
echo "🎉 You can now remove the USB drive and reboot"
echo
read -p "Reboot now? (y/N): " REBOOT_NOW

if [[ "$REBOOT_NOW" =~ ^[Yy]$ ]]; then
    echo "🔄 Rebooting..."
    sudo reboot
else
    echo "💡 Remember to remove USB drive before manual reboot!"
fi
