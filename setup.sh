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
cat >> /home/equa/.bashrc <<'EOF'
## .bashrc
# Functions
mdd() {
    mkdir -p "$1" && cd "$1"
}

drn() {
  image="$1"
  shift
  name="${image%%:*}"  # убираем тег (:latest)
  docker run -d --name "$name" "$image" "$@"
}

con() {
  nvim "$HOME/.config/$1"
}

# alias ls='ls -la'
alias g='grep'
alias l='ls'
alias ll='ls -lAh'
alias la='l -a'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias h='history -10'
alias cls='clear'
alias cl='clear'
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
alias gundo='git reset --soft HEAD~1'    # отмена последнего коммита, оставляя изменения
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
alias hypr='nvim ~/.config/hypr/hyprpaper.conf'
alias hyan='nvim ~/.config/hypr/conf/animation.conf'
alias hyap='nvim ~/.config/hypr/conf/appearance.conf'
alias hyau='nvim ~/.config/hypr/conf/autostart.conf'
alias hyi='nvim ~/.config/hypr/conf/input.conf'
alias hyk='nvim ~/.config/hypr/conf/keybinding.conf'
alias hyp='nvim ~/.config/hypr/conf/programs.conf'
alias hys='nvim ~/.config/hypr/conf/startworkspaces.conf'
alias hym='hyprctl monitors'
alias hyc='hyprctl clients'

# Pacman
alias pi='pacman -Qi'                     # инфо о пакете
alias ps='sudo pacman -S'
alias pr='sudo pacman -Rns'
alias pu='sudo pacman -Syu'
alias puc='sudo pacman -Syu --noconfirm'   # обновить без вопросов
alias pq='pacman -Qe'                     # только явно установленные

# yay 
alias yi='yay -Qi'
alias ys='yay -S'
alias yr='yay -Rns'
alias yu='yay -Syu'
alias yss='yay -Ss'
alias yq='yay -Qe'

# docker
alias d='docker'
alias ds='docker start'
alias dp='docker stop'
alias dr='drn'
alias dc='docker container'
alias di='docker images'
alias dps='docker ps -a'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcb='docker compose build'
alias dexec='docker exec -it'
alias drm='docker rm -f'
alias drmi='docker rmi'
alias dlogs='docker logs -f'
alias dbash='docker exec -it $(docker ps -q | head -n1) bash' # bash в первом контейнере

# systemctl
alias si='sudo systemctl status'
alias ss='sudo systemctl start'
alias se='sudo systemctl enable'
alias sd='sudo systemctl disable'

# wireguard
alias wu='wg-quick up wg0'
alias wd='wg-quick down wg0'
alias wr='wg-quick down wg0 && wg-quick up wg0'
alias wg='sudo wg'
alias wgconf='sudo nvim /etc/wireguard/wg0.conf'
alias wgc='sudo nvim /etc/wireguard/wg0.conf'
alias wc='sudo nvim /etc/wireguard/wg0.conf'

alias dd='DISPLAY=:0'
alias term='lxterminal -e'
alias tt='lxterminal -e'

# Run on start
c
export DISPLAY=:0
EOF

sudo cp /home/equa/.bashrc /root/.bashrc
    echo "Aliases and functions added to $BASHRC"
}

# ===== SETUP SSH =====
setup_ssh() {
    sudo curl https://github.com/equa-tory.keys >> "$HOME_DIR/.ssh/authorized_keys"
    sudo sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sudo systemctl restart sshd
    echo "SSH keys installed and config updated."
}

# ===== CONFIG =====
setup_config() {
    CONF_TAR="$HOME_DIR/Downloads/raspi-init/conf.tar"
    if [ -f "$CONF_TAR" ]; then
	tar -xf "$CONF_TAR" -C "$HOME_DIR"
        echo ".config folder restored from $CONF_TAR"
    else
        echo "conf.tar not found at $CONF_TAR"
    fi
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
    chown equa:equa $APPS_DIR $VENVS_DIR
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
sudo apt purge -y samba
sudo apt install -y samba

mkdir /etc/samba

if [ ! -f /etc/samba/smb.conf ]; then
sudo tee /etc/samba/smb.conf > /dev/null <<'EOF'
[global]
   workgroup = WORKGROUP
   server string = Samba Server
   netbios name = raspberrypi
   security = user
   map to guest = Bad User
   dns proxy = no
EOF
fi

cat <<'EOF' | sudo tee -a /etc/samba/smb.conf >/dev/null
[share]
path = /home/equa/Desktop/share
guest ok = yes
read only = no
force user = equa
force group = equa
EOF

mkdir -p /home/equa/Desktop/share
chown equa:equa /home/equa/Desktop/share
chmod 755 /home/equa/Desktop/share

sudo systemctl restart smbd
sudo systemctl restart nmbd

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
setup_config
setup_swap
setup_folders
install_htop
install_inkscape
install_samba
install_bcnc

echo "All done. Rebooting!"
sudo reboot
