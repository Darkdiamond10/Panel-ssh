#!/bin/bash

descargar() {
    local indice=$1
    if [[ -s "$front_file_local" ]]; then
        echo "✅ Archivo ya existe en $front_file_local"
        return 0
    fi
    if [[ $indice -ge ${#ENLACES[@]} ]]; then
        echo "❌ No se pudo descargar el archivo desde ninguno de los enlaces."
        return 1
    fi
    local url=${ENLACES[$indice]}
    local servidor=${SERVIDORES[$indice]}
    echo -ne "🔄 Intentando descargar desde: $servidor"
    if wget -q --no-check-certificate -t3 -T3 -O "$front_file_local" "$url"; then
        echo "✅ "
        chmod +x ${front_file_local}
        source ${front_file_local}
        return 0
    else
        echo -e "⚠️ \n $servidor Fallo. Reintentando con otro...\n"
        descargar $((indice+1))  # Recursión
    fi
}

repo_install(){
    system=$(cat -n /etc/issue |grep 1 |cut -d ' ' -f6,7,8 |sed 's/1//' |sed 's/      //')
    distro=$(echo "$system"|awk '{print $1}')
    case $distro in
        Debian)List_SRC=$(echo $system|awk '{print $3}'|cut -d '.' -f1);;
        Ubuntu)List_SRC=$(echo $system|awk '{print $2}'|cut -d '.' -f1,2);;
    esac
    link="https://raw.githubusercontent.com/ChumoGH/ADMcgh/main/Repositorios/$List_SRC.list"
    case $List_SRC in
        8*|9*|10*|11*|12*|16.04*|18.04*|20.04*|20.10*|21.04*|21.10*|22.04*)
            [[ ! -e /etc/apt/sources.list.back ]] && cp /etc/apt/sources.list /etc/apt/sources.list.back
            wget -O /etc/apt/sources.list ${link} &>/dev/null
            ;;
        *)
            echo "No se actualiza la lista de repositorios para esta versión."
            return 1
            ;;
    esac
}

cryptic_transform() {
    local original_text="$1"
    local transformed_text=""
    local text_length=$(expr length "$original_text")
    for ((i=1; i<=text_length; i++)); do
        local current_char=$(echo "$original_text" | cut -b $i)
        case $current_char in
            ".") current_char="+" ;;
            "x") current_char="." ;;
            "5") current_char="x" ;;
            "s") current_char="5" ;;
            "1") current_char="s" ;;
            "@") current_char="1" ;;
            "2") current_char="@" ;;
            "?") current_char="2" ;;
            "4") current_char="?" ;;
            "0") current_char="4" ;;
            "/") current_char="0" ;;
            "K") current_char="/" ;;
        esac
        transformed_text="${transformed_text}${current_char}"
    done
    echo "$transformed_text" | rev
}

fun_ip(){
    MIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
    MIP2=$(wget -qO- --no-cache --no-check-certificate --max-redirect=5 ipv4.icanhazip.com)
    [[ "$MIP" != "$MIP2" ]] && IP="$MIP2" || IP="$MIP"
    mkdir -p /bin/ejecutar
    echo $IP > /bin/ejecutar/IPcgh
    echo $IP
}

rutaSCRIPT () {
    act_ufw() {
        [[ -f "/usr/sbin/ufw" ]] && ufw allow 81/tcp; ufw allow 8888/tcp
    }
    [[ -z $(cat /etc/resolv.conf | grep "8.8.8.8") ]] && echo "nameserver	8.8.8.8" >> /etc/resolv.conf
    [[ -z $(cat /etc/resolv.conf | grep "1.1.1.1") ]] && echo "nameserver	1.1.1.1" >> /etc/resolv.conf
    cd $HOME
    msg -bar3
    cd $HOME
    [[ -e $HOME/lista ]] && rm -f $HOME/lista*
    [[ -d ${SCPinstal} ]] && rm -rf ${SCPinstal}
}

function_verify () {
    echo "verify" > $(echo -e $(echo 2f62696e2f766572696679737973|sed 's/../\\x&/g'))
    echo 'MOD @ChumoGH ChumoGHADM' > $(echo -e $(echo 2F7573722F6C69622F6C6963656E6365|sed 's/../\\x&/g'))
    [[ $(dpkg --get-selections|grep -w "libpam-cracklib"|head -1) ]] || apt-get install libpam-cracklib -y &> /dev/null
    echo -e '# Modulo @ChumoGH
password [success=default ignore=ignore] pam_unix.so obscure sha512
password requisite pam_deny.so
password required pam_permit.so' > /etc/pam.d/common-password && chmod +x /etc/pam.d/common-password
    systemctl enable cron &>/dev/null
    sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -p
    echo 'net.ipv6.conf.all.disable_ipv6=1' > /etc/sysctl.d/70-disable-ipv6.conf
    sysctl -p -f /etc/sysctl.d/70-disable-ipv6.conf
}

verificar_arq () {
    [[ ! -d ${SCPdir} ]] && mkdir ${SCPdir}
    mv -f ${SCPinstal}/$1 ${SCPdir}/$1 && chmod +x ${SCPdir}/$1
}

error_conex () {
    [[ -e $HOME/lista-arq ]] && list_fix=$(cat < $HOME/lista-arq) || list_fix=""
    msg -bar3
    echo -e "\033[41m     --      SISTEMA ACTUAL $(lsb_release -si) $(lsb_release -sr)      --"
    [[ "$list_fix" == "" ]] && {
        msg -bar3
        echo -e " ERROR (PORT 8888 TCP) ENTRE GENERADOR <--> VPS "
        echo -e "    NO EXISTE CONEXION ENTRE EL GENERADOR "
        echo -e "  - \e[mGENERADOR O KEYGEN COLAPSADO\e[0m - "
        msg -bar3
        echo -e "  - DIRIGETE AL BOT Y ESCRIBE /restart "
        echo -e "  - Y REINTENTA NUEVAMENTE CON SU KEY "
        msg -bar3
    }
    invalid_key
}

invalid_key () {
    [[ $1 == '--ban' ]] && {
        cd $HOME
        key_cache=""
        figlet " Key Invalida" | boxes -d stone -p a2v1 > error.log
        msg -bar3 >> error.log
        echo "  KEY NO PERMITIDA, ADQUIERE UN RESELLER OFICIAL" >> error.log
        msg -bar3 >> error.log
        echo "  KEY : ${key_cache}" >> error.log
        msg -bar3 >> error.log
        echo "  SU KEY ESTA EN BUG, POR IP DE LOG NO ACCESIBLE" >> error.log
        msg -bar3 >> error.log
        echo -e ' https://t.me/ChumoGH  - @ChumoGH' >> error.log
        msg -bar3 >> error.log
        rm -f /etc/PACKAGE
        cat error.log | lolcat
        exit&&exit&&exit&&exit
    }
    [[ -e $HOME/lista-arq ]] && list_fix=$(cat < $HOME/lista-arq) || list_fix=""
    echo -e ' '
    msg -bar3
    echo -e " \033[41m-- CPU :$(lscpu | grep "Vendor ID" | awk '{print $3}') SISTEMA : $(lsb_release -si) $(lsb_release -sr) --"
    [[ "$list_fix" == "" ]] && {
        msg -bar3
        echo -e " ERROR (PORT 8888 TCP) ENTRE GENERADOR <--> VPS "
        echo -e "    NO EXISTE CONEXION ENTRE EL GENERADOR "
        echo -e "  - \e[mGENERADOR O KEYGEN COLAPSADO\e[0m - "
        msg -bar3
        echo -e "  - DIRIGETE AL BOT Y ESCRIBE /restart "
        echo -e "  - Y REINTENTA NUEVAMENTE CON SU KEY "
        msg -bar3
    }
    [[ "$list_fix" == "KEY INVALIDA!" ]] && {
        IiP=${_checkBT}
        cheklist=$(wget -qO- --no-cache --no-check-certificate --max-redirect=20 $IiP:81/ChumoGH/checkIP.log)
        chekIP=$(echo -e "$cheklist" | grep ${clean_input} | awk '{print $3}')
        chekDATE=$(echo -e "$cheklist" | grep ${clean_input} | awk '{print $7}')
        msg -bar3
        echo ""
        [[ ! -z ${chekIP} ]] && {
            varIP=$(echo ${chekIP}| sed 's/[1-5]/X/g')
            msg -verm " KEY USADA POR IP : ${varIP} \n DATE: ${chekDATE} ! "
            echo ""
            msg -bar3
        } || {
            echo -e "    PRUEBA COPIAR BIEN TU KEY "
            [[ $(echo "$(cryptic_transform "$clean_input"|cut -d'/' -f2)" | wc -c ) -lt 2 ]] && echo -e "" || echo -e "\033[1 CONTENIDO DE LA KEY ES INCORRECTO"
            echo -e "   KEY NO COINCIDE CON EL CODEX DEL ADM "
            msg -bar3
            tput cuu1 && tput dl1
        }
    }
    msg -bar3
    [[ $(echo "$(cryptic_transform "$clean_input"|cut -d'/' -f2)" | wc -c ) -lt 2 ]] && echo -e "" || echo -e "\033[1 CONTENIDO DE LA KEY ES INCORRECTO"
    [[ -e $HOME/lista-arq ]] && rm $HOME/lista-arq
    cd $HOME
    figlet " Key Invalida" | boxes -d stone -p a2v1 > error.log
    msg -bar3 >> error.log
    echo "  Key Invalida, Contacta con tu Provehedor" >> error.log
    echo -e ' https://t.me/ChumoGH  - @ChumoGH' >> error.log
    msg -bar3 >> error.log
    cat error.log | lolcat
    echo -e "    \033[44m  Deseas Reintentar con OTRA KEY\033[m  :v"
    echo -ne "\033[0 "
    read -p "  Responde [ s | n ] : " -e -i "n" x
    [[ $x == @(s|S|y|Y) ]] && funkey || {
        exit&&exit
    }
}

os_system(){
    system=$(cat -n /etc/issue |grep 1 |cut -d ' ' -f6,7,8 |sed 's/1//' |sed 's/      //')
    distro=$(echo "$system"|awk '{print $1}')
    case $distro in
        Debian)vercion=$(echo $system|awk '{print $3}'|cut -d '.' -f1);;
        Ubuntu)vercion=$(echo $system|awk '{print $2}'|cut -d '.' -f1,2);;
    esac
    link="https://raw.githubusercontent.com/ChumoGH/ADMcgh/main/Repositorios/${vercion}.list"
}

funkey () {
    local _trix=$(fun_ip)
    local _v1=$(wget -q -T 5 -O - https://raw.githubusercontent.com/ChumoGH/ADMcgh/main/version/v-new.log)
    local Key
    local clean_input
    local _filtro
    while [[ ! $_filtro ]]; do
        clear
        [[ $(uname -m 2> /dev/null) == "x86_64" ]] && cpu_model="ARM64 Pro" || cpu_model=$(lscpu | grep "Vendor ID" | awk '{print $3}'|head -1)
        _sys="$(lsb_release -si)-$(lsb_release -sr)"
        msg -bar3
        echo -e "   \033[41m- CPU: \033[100m${cpu_model}\033[41m SISTEMA : \033[100m${_sys}\033[41m -\033[0m"
        msg -bar3
        print_center "${_trix}"
        msg -bar3
        echo -e "  ${FlT}${rUlq} ADMcgh+ ${_v1} | @ChumoGH OFICIAL 2025 ${rUlq}${FlT}  -" | lolcat
        msg -bar3
        figlet ' . ADMcgh . ' | boxes -d stone -p a0v0 | lolcat
        echo "           PEGA TU KEY DE INSTALACION " | lolcat
        msg -bar3
        read -p "$(echo -e " \033[41m Key : \033[0")" _filtro
        clean_input="${_filtro}"
        local uncryp=$(cryptic_transform $clean_input)
        local uncryp2=$(echo $uncryp | cut -d '/' -f2)
    done
    cd $HOME
    IiP=$(cryptic_transform "$clean_input" | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    if lang_content=$(wget -q -T 5 -O - "$lang_url"); then
        if [[ $lang_content =~ ${IiP} ]]; then
            _CONTENIDO="${IiP}:${uncryp}"
            _checkBT="${IiP}"
            _key="${_checkBT}:8888/${uncryp2}/-SPVweN"
        else
            unset _checkBT
        fi
    else
        unset _checkBT
    fi
    new_id=$(uuidgen)
    [[ -z ${new_id} ]] && new_id="${_checkBT}-${IP}"
    if wget --no-cache --no-check-certificate --max-redirect=5 -qO- "${_checkBT}:8888" >/dev/null; then
        tput cuu1 && tput dl1
        msg -bar3
        echo -ne " \e[90m\e[43m CHEK KEY : \033[m"
        echo -e " \e[2m ENLAZADA AL GENERADOR\e[0m" | pv -qL 50
        tput cuu1 && tput dl1
        echo -ne " \033[m ESTATUS : \033[3m"
        tput cuu1 && tput dl1
        echo -ne "\033[1 [ \e[32m VALIDANDO CONEXION \e[0m \033[34m]\033[0m"
        if wget --no-cache --no-check-certificate --max-redirect=5 -O $HOME/lista-arq ${_key}/$_trix/$_sys/${new_id}  &>/dev/null; then
            echo -e "\033[34m [ \e[2m DONE \e[0m \033[1]\033[0m"
        else
            echo -e "\033[34m [ \e[1m FAIL \e[0m \033[1]\033[0m"
            invalid_key && exit
        fi
        echo "${new_id}" > /linux-kernel
        [[ -d /etc/adm-lite/userDIR/ ]] && {
            mkdir /USERS &>/dev/null
            mv /etc/adm-lite/userDIR/* /USERS/
        }
        if [ -z "${_checkBT}" ]; then
            rm -f $HOME/lista*
            tput cuu1 && tput dl1
            echo -e "\n\e[31mRECHAZADA, POR GENERADOR NO AUTORIZADO!!\e[0m\n" && _sleepColor '1'
            echo
            echo -e "\e[mESTE USUARIO NO ESTA AUTORIZADO !!\e[0m" && _sleepColor '1'
            invalid_key "--ban" $_filtro
            exit
            tput cuu1 && tput dl1
        fi
    else
        case $? in
            28)
                echo -e "\e[m TIEMPO DE CONEXION AGOTADO (28) \e[0m" && sleep 1s
                invalid_key && exit
                ;;
            *)
                echo -e "\e[m CONEXION FTP NO ESTABLECIDA (7)\e[0m" && sleep 1s
                invalid_key && exit
                ;;
        esac
    fi
    sleep 1s
    tput cuu1 && tput dl1
    echo -ne "\033[1 COMPILANDO VIA\033[m \033[1HTTPS \033[1 127.0.0.1:81 \033[1.\033[33m.\033[1m. \033[3m"
    helice
    echo -e "\e[1DOk"
    msg -bar3
    if [[ -e $HOME/lista-arq ]] && [[ ! $(cat $HOME/lista-arq|grep "KEY INVALIDA!") ]]; then
        [[ -e ${SCPdir}/menu ]] && {
            echo $clean_input > /etc/cghkey
            clear
            rm -f $HOME/log.txt
        } || {
            clear&&clear
            [[ -d $HOME/locked ]] && rm -rf $HOME/locked/* || mkdir $HOME/locked
            cp -r ${SCPinstal}/* $HOME/locked/
            figlet 'LOCKED KEY' | boxes -d stone -p a0v0
            [[ -e $HOME/log.txt ]] && ff=$(cat < $HOME/log.txt | wc -l) || ff="LL"
            msg -ne " ${aLerT} "
            echo -e "\033[31m [ $ff FILES DE KEY BLOQUEADOS ] " | pv -qL 50 && msg -bar3
            echo -e " APAGA TU CORTAFUEGOS O HABILITA PUERTO 81 Y 8888"
            echo -e "   ---- AGREGANDO REGLAS AUTOMATICAS ----"
            act_ufw
            echo -e "   Si esto no funciona PEGA ESTOS COMANDOS  "
            echo -e "   sudo ufw allow 81 && sudo ufw allow 8888 "
            msg -bar3
            echo -e "             sudo apt purge ufw -y"
            invalid_key && exit
        }
        [[ -d /etc/alx ]] || mkdir /etc/alx
        [[ -e /etc/folteto ]] && rm -f /etc/folteto
        [[ -e /bin/ejecutar/IPcgh ]] && rm -f /bin/ejecutar/IPcgh
        msg -bar3
        function_verify
        fun_install "${clean_input}"
    else
        invalid_key
    fi
    sudo sync
    echo 3 > /proc/sys/vm/drop_caches
    sysctl -w vm.drop_caches /dev/null 2>&1
}
