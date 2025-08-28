#!/bin/bash
set -e

# ===== VARIABLES =====
USER="equa"
HOME_DIR="/home/$USER"
BASHRC="$HOME_DIR/.bashrc"
APPS_DIR="$HOME_DIR/apps"
VENVS_DIR="$HOME_DIR/venvs"
DESKTOP="$HOME_DIR/Desktop"

# ===== FUNCTIONS =====
add_to_bashrc() {
    cat >> "$BASHRC" <<'EOF'
# ===== FUNCTIONS =====
mdd() { mkdir -p "$1" && cd "$1"; }
drn() { image="$1"; shift; name="${image%%:*}"; docker run -d --name "$name" "$image" "$@"; }
con() { nvim "$HOME/.config/$1"; }

alias g='grep'
alias l='ls'
alias ll='ls -lAh'
alias la='l -a'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias h='history -10'
alias cls='clear'
alias c='clear'
alias r='source ~/.zshrc'
alias py='python3'
alias vnv='source venv/bin/activate'
alias vnvv='python3 -m venv venv && source venv/bin/activate'
alias deac='deactivate'
alias vim='nvim'
alias v='nvim'
alias md='mdd'
alias x='exit'
alias q='exit'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gb='git branch'
alias gco='git checkout'
alias gcm='git checkout main'
alias gcb='git checkout -b'
alias gundo='git reset --soft HEAD~1'
alias ip='curl ifconfig.me'
alias desk='cd ~/Desktop'
alias dl='cd ~/Downloads'
alias dev='cd ~/Developer'
alias dv='cd ~/Developer'
alias a='alias | grep'
alias sq='sqlite3'
alias sql='sqlite3'
alias pi='pip install'
alias pun='pip uninstall'
alias pl='pip list'
alias pls='pip list'
alias pfree='pip freeze > requirements.txt'
alias preq='pip install -r requirements.txt'
alias n='nano'
alias s='sudo'
alias co='con'
alias ff='clear; fastfetch'
alias tren='trans -b :en'
alias trru='trans -b :ru'
alias o='open'
alias zrc='nvim ~/.zshrc'

EOF
    echo "Aliases and functions added to $BASHRC"
}

# ===== SETUP SSH =====
setup_ssh() {
    sudo curl https://github.com/equa-tory.keys >> "$HOME_DIR/.ssh/authorized_keys"
    sudo sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sudo systemctl restart sshd
    echo "SSH keys installed and config updated."
}

# ===== SWAP =====
setup_swap() {
    sudo sed -i "s/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=1024/" /etc/dphys-swapfile
    sudo dphys-swapfile setup
    sudo dphys-swapfile swapon
    echo "Swap file updated."
}

# ===== FOLDERS =====
setup_folders() {
    mkdir -p "$APPS_DIR" "$VENVS_DIR"
    mkdir -p "$DESKTOP/Desktop"
    echo "Folders created."
}

# ===== APPLICATIONS =====
install_htop() {
    cat >> "$DESKTOP/htop.sh" << 'EOF'
#!/bin/bash
lxterminal -e htop
EOF
    sudo chmod +x "$DESKTOP/htop.sh"
    echo "htop script created."
}

install_inkscape() {
    sudo apt install -y inkscape
    cat >> "$DESKTOP/inkscape.sh" << 'EOF'
#!/bin/bash
inkscape
EOF
    sudo chmod +x "$DESKTOP/inkscape.sh"
    echo "Inkscape installed and shortcut created."
}

install_samba() {
    sudo apt install -y samba
    mkdir -p "$DESKTOP/share"
    sudo chmod 777 "$DESKTOP/share" "$DESKTOP" "$HOME_DIR"
    cat <<'EOF' | sudo tee -a /etc/samba/smb.conf >/dev/null
[share]
path = /home/equa/Desktop/share
guest ok = yes
read only = no
force user = equa
force group = equa
EOF
    echo "Samba installed and share configured."
}

install_bcnc() {
    sudo apt update
    sudo apt install -y python3 python3-tk python3-pip
    python3 -m venv "$VENVS_DIR/venv-bcnc"
    source "$VENVS_DIR/venv-bcnc/bin/activate"
    pip install --upgrade bCNC
    cat >> "$DESKTOP/bCNC.sh" << 'EOF'
#!/bin/bash
source /home/equa/venvs/venv-bcnc/bin/activate
python3 -m bCNC
EOF
    sudo chmod +x "$DESKTOP/bCNC.sh"
    echo "bCNC installed and shortcut created."
}

# ===== MAIN =====
add_to_bashrc
setup_ssh
setup_swap
setup_folders
install_htop
install_inkscape
install_samba
install_bcnc

echo "All done. Rebooting!"
sudo reboot
