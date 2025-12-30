#!/bin/bash
set -o pipefail
shopt -s extglob

# 1. Load Globals and Utilities
source globals.sh
source utils.sh

# 2. Root Check
if ! [ $(id -u) = 0 ]; then
    clear
    echo ""
    echo " "
    echo " 	           	!!!     Error Fatal!! x000e1  !!!"
    echo " "
    echo "                    ! Este script debe ejecutarse como root! !"
    echo "                              Como Solucionarlo "
    echo "                            Ejecute el script asi:"
    echo "                                     "
    echo "                                (  sudo -i )"
    echo "                                   sudo su"
    echo "                                 Retornando . . ."
    echo $(date)
    exit
fi

# 3. Load External UI ('msg' script)
if [[ ! -s "$front_file_local" ]]; then
    descargar 0
else
    chmod +x ${front_file_local}
    source ${front_file_local}
fi

# 4. Load UI and Install Logic
source ui.sh
source install.sh

# 5. Initial Prompt (Repo Install)
msg -bar3
print_center -verm2 '\n\nADVERTENCIA!!!\n\n'
msg -bar3
print_center -verd "\n ACTUALIZAR LAS APT.LIST PUEDE CAUSAR ERRORES \n ¿DESEAS ACTUALIZAR LAS APT.LIST? (s/n)\n "
msg -bar3
print_center -ama  " ( OPCIONAL )\n"
msg -bar3
echo -ne "\033[0"
read -t 10 -p " Responde [ s | n ] : " -e -i "n" respuesta
echo ''
if [[ "$respuesta" == @(s|S|y|Y|si|Si|SI|yes|Yes) ]]; then
    repo_install
fi

# 6. Initial Cleanup
rm "$0" &>/dev/null
script_name=$(basename "$0") &>/dev/null
rm -f $(pwd)/${script_name} &>/dev/null
rm -f /file
rm -rf /tmp/* &>/dev/null
killall apt apt-get &> /dev/null
kill $(ps x | grep apt | grep -v grep | cut -d ' '  -f3) &> /dev/null
apt --fix-broken install
dpkg --configure -a

fecha=$(date +"%d-%m-%y")
TIME_START="$(date +%s)"
DOWEEK="$(date +'%u')"
[[ -e $HOME/cgh.sh ]] && rm $HOME/cgh.*
rm -f instala.*
[[ -e /etc/folteto ]] && rm -f /etc/folteto
[[ -e /bin/ejecutar/IPcgh ]] && rm -f /bin/ejecutar/IPcgh

# 7. Main Logic with Argument Check
if [[ ! -z $1 ]]; then
    # Verify exact argument
    if [[ "$1" == "--ADMcgh" ]]; then
        echo -e " ESPERE UN MOMENTO $1"
    else
        exit && exit
    fi

    # Cleanup specific to this block
    rm -f wget*
    [[ $(dpkg --get-selections|grep -w "curl"|head -1) ]] || _sleepColor '' 'apt-get -qq install curl -y'
    [[ $(dpkg --get-selections|grep -w "bzip2"|head -1) ]] || _sleepColor '' 'apt-get -qq install bzip2 -y'
    dpkg-reconfigure --frontend noninteractive tzdata >/dev/null 2>&1
    [[ $(dpkg --get-selections|grep -w "sudo"|head -1) ]] || _sleepColor '' 'apt-get -qq install sudo -y'
    [[ $(dpkg --get-selections|grep -w "curl"|head -1) ]] || _sleepColor '' 'apt -qq install curl -y'
    [[ $(dpkg --get-selections|grep -w "uuid-runtime"|head -1) ]] || _sleepColor '' 'apt-get -qq install uuid-runtime -y'

    _double=$(wget -q -T 5 -O - "https://raw.githubusercontent.com/ChumoGH/ADMcgh/refs/heads/main/TOKENS/dinamicos/control")
    COLS=$(tput cols)

    fun_ip &>/dev/null

    # Execution Logic
    [[ -e /etc/PACKAGE ]] || update_pak
    clear&&clear

    # We need to call os_system here to ensure 'distro' and 'vercion' are set for rutaSCRIPT
    os_system

    rutaSCRIPT ${distro} ${vercion}
    rm -f setup* lista*
    _temp=$(mktemp)
    chmod +x ${_temp}

    funkey

    tittle || true  # Add || true just in case

    echo -e " TIEMPO DE EJECUCION $((($(date +%s)-$TIME_START)/60)) min."
    msg -bar3

    cat <<MENU > ${_temp}
sleep 2s
cd $HOME
rm -f "${0}" &>/dev/null || true
if command -v menu >/dev/null 2>&1; then
    echo -e "\n TIEMPO DE EJECUCION $((($(date +%s)-$TIME_START)/60))"
    echo -e "INSTALL COMPLETED! WRITE menu"
else
    echo -e " INSTALACION NO COMPLETADA CON EXITO !"
fi
kill $(ps x | grep setup | grep -v grep| cut -d ' '  -f3) &>/dev/null
rm -f setup* lista* &>/dev/null
exit&&exit&&exit
MENU

    tput cuu1 && tput dl1
    tput cuu1 && tput dl1
    echo -e " ${aLerT} RESTART IS RECOMMENDED TO OPTIMIZE PACKAGES ${aLerT}"
    echo -ne " DO YOU WANT TO RESTART?:"
    read -p " [Y/N]: " -e -i n rac
    [[ "$rac" == @(s|S|y|Y) ]] && {
        countdown 5
    }
    tput cuu1 && tput dl1
    tput cuu1 && tput dl1
    read -p " $( echo -e "PRESIONA ENTER PARA FINALIZAR INSTALACION \n $(msg -bar3)")"
    [[ -e "$(which menu)" ]] && bash ${_temp} &
    [[ -d /USERS ]] && mv /USERS/* /etc/adm-lite/userDIR/ &>/dev/null && rm -rf /USERS
    exit

else
    # Fallback if no arguments
    echo -e " NO SE RECIVIO PARAMETROS "
    rm -f setup*
    rm -f /etc/folteto
    rm -rf /tmp/*
fi
