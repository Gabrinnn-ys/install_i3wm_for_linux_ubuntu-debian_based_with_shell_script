#!/usr/bin/env bash

# Script para instalar um ambiente i3wm completo em Debian/Ubuntu
# Inclui Xorg, i3, ferramentas úteis e arquivos de configuração básicos

set -euo pipefail

FORCE=0
WITH_DM=0

usage(){
  cat <<EOF
Uso: $0 [--with-lightdm] [--force]

  --with-lightdm   instala o display manager LightDM (opcional)
  --force          sobrescreve configs existentes sem perguntar
  --help           exibe esta ajuda
EOF
}

while [[ ${#} -gt 0 ]]; do
  case "$1" in
    --with-lightdm) WITH_DM=1; shift;;
    --force) FORCE=1; shift;;
    --help) usage; exit 0;;
    *) echo "Opção desconhecida: $1"; usage; exit 1;;
  esac
done

if ! command -v apt-get >/dev/null 2>&1; then
  echo "Este script requer apt-get (Debian/Ubuntu). Saindo." >&2
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  SUDO=sudo
else
  SUDO=""
fi

export DEBIAN_FRONTEND=noninteractive

PACKAGES=(
  xorg xserver-xorg xinit i3 i3status i3lock dmenu rofi feh picom
  network-manager-gnome nm-applet pulseaudio pavucontrol pulseaudio-utils alsa-utils
  xterm xdg-utils git curl fonts-noto fonts-noto-cjk fonts-font-awesome
)

if [[ $WITH_DM -eq 1 ]]; then
  PACKAGES+=(lightdm)
fi

echo "Atualizando repositórios e instalando pacotes..."
${SUDO} apt-get update
${SUDO} apt-get install -y "${PACKAGES[@]}"

echo "Instalação de pacotes concluída. Criando configurações de usuário..."

USER_HOME=${SUDO:+/root}
if [[ -n "$SUDO" ]]; then
  # when not root, set to invoking user's home
  INVOKER=$(logname 2>/dev/null || true)
  if [[ -n "$INVOKER" ]]; then
    USER_HOME=$(eval echo "~$INVOKER")
  else
    USER_HOME="$HOME"
  fi
else
  USER_HOME="$HOME"
fi

mkdir -p "$USER_HOME/.config/i3"
mkdir -p "$USER_HOME/.config/i3status"
mkdir -p "$USER_HOME/.config/picom"

CONFIG_I3="$USER_HOME/.config/i3/config"
CONFIG_I3STATUS="$USER_HOME/.config/i3status/config"
XINITRC="$USER_HOME/.xinitrc"

cat > "$CONFIG_I3" <<'EOF'
# Arquivo de configuração i3 básico
set $mod Mod4
set $term xterm

# Font
font pango:DejaVu Sans 10

# keybindings
bindsym $mod+Return exec $term
bindsym $mod+d exec rofi -show drun
bindsym $mod+Shift+q kill
bindsym $mod+Shift+r restart
bindsym $mod+Shift+e exec i3-msg exit

# lock and logout
bindsym $mod+Shift+x exec i3lock

# workspaces
set $ws1 1
set $ws2 2
set $ws3 3
set $ws4 4
set $ws5 5

bindsym $mod+1 workspace $ws1
bindsym $mod+2 workspace $ws2
bindsym $mod+3 workspace $ws3
bindsym $mod+4 workspace $ws4
bindsym $mod+5 workspace $ws5

# Autostart
exec --no-startup-id picom --config $HOME/.config/picom/picom.conf
exec --no-startup-id nm-applet
exec --no-startup-id feh --bg-scale $HOME/Pictures/wallpaper.jpg || true

bar {
  status_command i3status
}

EOF

cat > "$CONFIG_I3STATUS" <<'EOF'
general {
  output_format = "i3bar"
  colors = true
}

order += "cpu"
order += "memory"
order += "disk /"
order += "battery"
order += "load"
order += "time"

cpu {
  format = "CPU: %usage%"
}

memory {
  format = "RAM: %used%MB"
}

disk "/" {
  format = "HD: %free%"
}

battery {
  format = "BAT: %status% %percentage%%"
}

load {
  format = "Load: %1min%"
}

time {
  format = "%Y-%m-%d %H:%M"
}

EOF

cat > "$XINITRC" <<'EOF'
# ~/.xinitrc
exec i3
EOF

# picom minimal config
cat > "$USER_HOME/.config/picom/picom.conf" <<'EOF'
backend = "glx";
vsync = true;
opacity-rule = ["90:class_g = 'i3-frame'"];
EOF

chown -R $(logname 2>/dev/null || whoami):$(id -gn $(logname 2>/dev/null || whoami) 2>/dev/null || id -gn) "$USER_HOME/.config" || true

echo "Configurações criadas em $USER_HOME/.config/i3 e .xinitrc"

cat <<'EOF'

Pronto — script completado.

Arquivos criados (se não existiam):
- $CONFIG_I3
- $CONFIG_I3STATUS
- $XINITRC

Para iniciar o i3 a partir de uma sessão gráfica normalmente use um display manager,
ou inicie com startx (vai usar ~/.xinitrc). Se instalou com --with-lightdm, reinicie o sistema.

Exemplo de uso (não rode como root):
  chmod +x install_i3.sh
  ./install_i3.sh [--with-lightdm] [--force]

EOF

exit 0
