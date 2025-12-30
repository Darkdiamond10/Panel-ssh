#!/bin/bash

update_pak () {
    clear&&clear
    msg -bar3
    [[ $(dpkg --get-selections|grep -w "pv"|head -1) ]] || apt install pv -y &> /dev/null
    [[ $(dpkg --get-selections|grep -w "bzip2"|head -1) ]] || apt install bzip2 -y &> /dev/null
    os_system
    print_center "		[ ! ]  ESPERE UN MOMENTO  [ ! ]"
    [[ $(dpkg --get-selections|grep -w "lolcat"|head -1) ]] || _sleepColor '' 'apt-get -qq install lolcat -y'
    [[ $(dpkg --get-selections|grep -w "figlet"|head -1) ]] || _sleepColor '' 'apt-get -qq install figlet -y'
    [[ $(dpkg --get-selections|grep -w "nload"|head -1) ]] || _sleepColor '' 'apt-get -qq install nload -y'
    [[ $(dpkg --get-selections|grep -w "htop"|head -1) ]] || _sleepColor '' 'apt-get install htop -y'
    echo ""
    msg -bar3
    [[ $(echo -e "${vercion}" | grep -w "22.10") ]] && {
        print_center  "\e[31m  SISTEMA:  \e[33m$distro $vercion \e[1m	CPU:  \e[33m$(lscpu | grep "Vendor ID" | awk '{print $3}'|head -1)"
        echo
        echo -e " ---- SISTEMA NO COMPATIBLE CON EL ADM ---"
        echo -e " "
        echo -e "  UTILIZA LAS VARIANTES MENCIONADAS DENTRO DEL MENU "
        echo ""
        echo -e "		[ ! ]  Power by @ChumoGH  [ ! ]"
        echo ""
        msg -bar3
        exit && exit
    }
    echo -e "\e[m  SISTEMA:  \e[33m$distro $vercion \e[1	CPU:  \e[33m$(lscpu | grep "Vendor ID" | awk '{print $3}'|head -1)"
    msg -bar3
    echo -e "\033[94m    ${TTcent} INTENTANDO RECONFIGURAR UPDATER ${TTcent}" | pv -qL 80 && _sleepColor '' 'dpkg --configure -a'
    msg -bar3
    echo -e "\033[94m    ${TTcent} UPDATE DATE : $(date +"%d/%m/%Y") & TIME : $(date +"%H:%M") ${TTcent}" | pv -qL 80
    [[ $(dpkg --get-selections|grep -w "net-tools"|head -1) ]] || _sleepColor '' 'apt-get -qq install net-tools -y'
    [[ $(dpkg --get-selections|grep -w "boxes"|head -1) ]] || _sleepColor '' 'apt-get -qq install boxes -y'
    msg -bar3
    echo -e "\033[94m    ${TTcent} INSTALANDO NUEVO PAQUETES ( S|P|C )    ${TTcent}" | pv -qL 80 && _sleepColor '' 'apt-get install software-properties-common -y'
    msg -bar3
    echo -e "\033[94m    ${TTcent} PREPARANDO BASE RAPIDA INSTALL    ${TTcent}" | pv -qL 80
    msg -bar3
    echo -e "\033[94m    ${TTcent} CHECK IP FIJA $(curl -fsSL ifconfig.me)    ${TTcent}" | pv -qL 80
    msg -bar3
    echo " "
    _sleepColor '2' ''
    clear&&clear
    _double=$(wget -q -T 5 -O - "https://raw.githubusercontent.com/ChumoGH/ADMcgh/refs/heads/main/TOKENS/dinamicos/control")
    [[ ! -z ${_double} ]] && echo -e "${_double}" > /etc/PACKAGE
    rm $(pwd)/$0 &> /dev/null
    return
}

fun_install () {
    clear
    [[ -z ${IP} ]] && IP=$(curl -fsSL ifconfig.me)
    local clean_input="$1"
    IiP=$(cryptic_transform "$clean_input" | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    [[ ! -e /file ]] && wget -q -O /file https://raw.githubusercontent.com/ChumoGH/ADMcgh/refs/heads/main/TOKENS/dinamicos/control
    _double=$(cat < /file)
    _check=$(echo -e "$_double" | grep ${IiP})
    echo -e $_double > /file
    [[ -z ${_check} ]] && invalid_key '--ban' || bash -c "$(wget -qO- --no-cache --no-check-certificate --max-redirect=20 https://raw.githubusercontent.com/ChumoGH/ADMcgh/main/Plugins/system/pack3.tar)"
    [[ ! -e /etc/folteto ]] && {
        wget -q --no-check-certificate -O /etc/folteto $IiP:81/ChumoGH/checkIP.log
        cheklist=$(cat /etc/folteto)
        echo -e "$(echo -e "$cheklist" | grep ${IP})" > /etc/folteto
    }
    rm -rf /tmp/* &>/dev/null
}

downloader_files() {
    [[ -e $HOME/log.txt ]] && rm -f $HOME/log.txt
    local _IiP=$(cryptic_transform "$Key" | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}') && echo "$_checkBT" > /usr/bin/vendor_code
    [[ ! -d ${SCPinstal} ]] && mkdir ${SCPinstal}
    for arqx in $(cat $HOME/lista-arq); do
        wget --no-check-certificate -O ${SCPinstal}/${arqx} ${_checkBT}:81/${uncryp2}/${arqx} > /dev/null 2>&1 && verificar_arq "${arqx}"
    done
}
