#!/bin/bash

# Environment Variables
export DEBIAN_FRONTEND=noninteractive
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/

# Paths and URLs
export front_file_local="/bin/ejecutar/msg"
export SCPdir="/etc/adm-lite"
export SCPinstal="$HOME/install"
export lang_url="https://raw.githubusercontent.com/ChumoGH/ADMcgh/refs/heads/main/TOKENS/dinamicos/control"

# Download Links
ENLACES=(
"https://raw.githubusercontent.com/ChumoGH/ADMcgh/main/Plugins/system/styles.cpp"
"https://www.dropbox.com/scl/fi/je70qpfmwu6416ail48zq/msg?rlkejg8eazt0p95pkq0xj4ckrrt1y"
"https://plus.admcgh.site/ChumoGH/msg"
)

SERVIDORES=(
"GitHUB"
"DropBox"
"ChumoGH SIte"
)

# Colors
export c_default="\033[0m"
export c_blue="\033[0;34m"
export c_magenta="\033[1;35m"
export c_cyan="\033[0;36m"
export c_green="\033[1;32m"
export c_red="\033[1;31m"
export c_yellow="\033[1;33m"

# Animation Frames
anim=(
"${c_blue}${t0gSl}${c_green}${t0gSl}${c_red}${t0gSl}${c_magenta}${t0gSl}    "
" ${c_green}${t0gSl}${c_red}${t0gSl}${c_magenta}${t0gSl}${c_blue}${t0gSl}   "
"  ${c_red}${t0gSl}${c_magenta}${t0gSl}${c_blue}${t0gSl}${c_green}${t0gSl}  "
"   ${c_magenta}${t0gSl}${c_blue}${t0gSl}${c_green}${t0gSl}${c_red}${t0gSl} "
"    ${c_blue}${t0gSl}${c_green}${t0gSl}${c_red}${t0gSl}${c_magenta}${t0gSl}"
)
