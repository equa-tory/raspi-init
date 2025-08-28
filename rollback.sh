#!/bin/bash

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# ! I DO NO RECOMMEND USING THIS SCRIPT !
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


set -e

USER="equa"
HOME_DIR="/home/$USER"
BASHRC="$HOME_DIR/.bashrc"
APPS_DIR="$HOME_DIR/apps"
VENVS_DIR="$HOME_DIR/venvs"
DESKTOP="$HOME_DIR/Desktop"

# ===== FUNCTIONS =====
remove_bashrc_entries() {
    # Удаляем все алиасы и функции, добавленные нашим скриптом
    sed -i '/# ===== FUNCTIONS =====/,/# ===== FUNCTIONS ===== END =====/d' "$BASHRC" || true
    echo "Aliases and functions removed from $BASHRC"
}

remove_ssh_keys() {
    sudo sed -i '/equa-tory.keys/d' "$HOME_DIR/.ssh/authorized_keys" || true
    echo "SSH keys removed from authorized_keys"
}

remove_swap() {
    sudo sed -i "s/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=512/" /etc/dphys-swapfile
    sudo dphys-swapfile setup
    sudo dphys-swapfile swapon
    echo "Swap file reset to default"
}

remove_folders() {
    rm -rf "$APPS_DIR" "$VENVS_DIR" "$DESKTOP/htop.sh" "$DESKTOP/inkscape.sh" "$DESKTOP/bCNC.sh" "$DESKTOP/share"
    echo "Folders and desktop scripts removed"
}

remove_apps() {
    # apt packages
    sudo apt remove --purge -y inkscape samba python3-tk
    sudo apt autoremove -y
    echo "Apt packages removed"

    # Python venvs
    rm -rf "$VENVS_DIR/venv-bcnc"
    echo "Python virtual environments removed"

    # Samba config
    sudo sed -i '/\[share\]/,/^$/d' /etc/samba/smb.conf
    echo "Samba config removed"
}

# ===== MAIN =====
remove_bashrc_entries
remove_ssh_keys
remove_swap
remove_folders
remove_apps

echo "All done. Reboot recommended."
