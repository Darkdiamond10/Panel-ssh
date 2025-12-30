#!/bin/bash

fun_bar () {
    comando[0]="$1"
    (
    [[ -e $HOME/fim ]] && rm $HOME/fim
    ${comando[0]} -y > /dev/null 2>&1
    touch $HOME/fim
    ) > /dev/null 2>&1 &
    echo -ne "\033[1 ["
    while true; do
        for((i=0; i<18; i++)); do
            echo -ne "\033[1##"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[33m]"
        sleep 0.5s
        tput cuu1
        tput dl1
        echo -ne "\033[1 ["
    done
    echo -e "\033[33m]\033[1m -\033[2m 100%\033[m"
}

start_animation() {
    [[ "${silent_mode}" == "true" ]] && return 0
    setterm -cursor off
    (
    while true; do
        for i in {0..4}; do
            echo -ne "\r\033[2K                         ${anim[i]}"
            sleep 0.1
        done
        for i in {4..0}; do
            echo -ne "\r\033[2K                         ${anim[i]}"
            sleep 0.1
        done
    done
    ) &
    export ANIM_PID="${!}"
}

stop_animation() {
    [[ "${silent_mode}" == "true" ]] && return 0
    [[ -e "/proc/${ANIM_PID}" ]] && kill -13 "${ANIM_PID}"
    setterm -cursor on
}

_sleepColor(){
    local time=$1
    local accion=$2
    start_animation
    [[ -z ${accion} ]] && {
        [[ -z ${time} ]] && sleep 2s || sleep ${time}
    } || ${accion} &>/dev/null
    stop_animation
    echo
    tput cuu1 >&2 && tput dl1 >&2
}

print_countdown() {
    echo -ne "\r REINICIANDO EN : $1 seconds    "
}

countdown() {
    local seconds=$1
    while [ "$seconds" -gt 0 ]; do
        print_countdown "$seconds"
        sleep 1
        seconds=$((seconds - 1))
    done
    echo -e "\rRESTART complete!         "
    sudo reboot
}

helice() {
    downloader_files >/dev/null 2>&1 &
    tput civis
    while [ -d /proc/$! ]; do
        for i in / - \\ \|; do
            sleep .1
            echo -ne "\e[1D$i"
        done
    done
    tput cnorm
}
