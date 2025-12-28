# install_i3 — Instalação automática de i3wm para Debian/Ubuntu

Resumo
-----
Script que instala um ambiente i3wm completo em sistemas Debian/Ubuntu. Inclui Xorg, i3, utilitários comuns (rofi, dmenu, picom, feh), gerenciamento de rede e áudio, fontes básicas e arquivos de configuração mínimos.

Requisitos
----------
- Sistema Debian/Ubuntu (ou derivado) com `apt` disponível.
- Acesso a uma conta com sudo para instalar pacotes.

Instalação
---------
1. Copie ou abra o script `install_i3.sh` na sua máquina.
2. Torne executável e execute (não rode como root diretamente):

```bash
chmod +x "Shell's"/install_i3.sh
./"Shell's"/install_i3.sh [--with-lightdm] [--force]
```

Opções
------
- `--with-lightdm`: instala o display manager LightDM para login gráfico.
- `--force`: sobrescreve arquivos de configuração existentes sem pedir confirmação.

O que o script faz
-------------------
- Atualiza os repositórios e instala os pacotes necessários via `apt`.
- Cria um layout básico de `~/.config/i3/config`, `~/.config/i3status/config`, `~/.config/picom/picom.conf` e `~/.xinitrc` (se não existirem, ou se `--force` for usado).
- Configura autostart para `picom`, `nm-applet` e define atalhos básicos do i3.

Como iniciar o i3
-----------------
- Se instalou um display manager (`--with-lightdm`), reinicie e selecione i3 na tela de login.
- Para iniciar manualmente sem DM, use `startx` (usa `~/.xinitrc`).

Notas e cuidados
-----------------
- O script instala pacotes que exigem espaço em disco e dependências de sistema; revise a lista de pacotes no próprio script antes de rodar.
- Recomendo executar uma cópia do script em uma VM primeiro, se for um sistema crítico.
- Personalize `~/.config/i3/config` e `~/.config/picom/picom.conf` após a instalação conforme suas preferências.

Arquivos relevantes
-------------------
- `Shell's/install_i3.sh` — script de instalação principal
- `~/.config/i3/config` — configuração do i3 (criada automaticamente)
- `~/.config/i3status/config` — configuração do i3status (criada automaticamente)
- `~/.config/picom/picom.conf` — configuração do compositor (criada automaticamente)

Próximos passos
---------------
- Rodar o script no sistema alvo quando estiver pronto.
- Se quiser, posso: ajustar a lista de pacotes, adicionar suporte a ZSH, criar temas para i3 ou gerar um arquivo de exemplo de wallpaper.
