#!/bin/bash
#Author: Hunkar Ciplak, 05.2021

f_name=${0##*/}
var=$(lsusb | awk '/J-Link/{print $0; exit}')

if [[ -z $var ]]; then
        echo "<$f_name>J-Link not found!"
        exit 1
fi

IFS=' '
tokens=( $var )
bus=${tokens[1]}
device=$(echo ${tokens[3]} |awk '{ print substr( $0, 1, length($0)-1 ) }')
if [[ -n $bus ]] && [[ -n $device ]]; then
        app=$(lsof /dev/bus/usb/$bus/$device)
        if [[ -z $app ]]; then
                echo "<$f_name>Device is not in use!"
        else
                app_tokens=( $app )
                index=$(expr index "${app_tokens[8]}" $'\n')
                app_name=${app_tokens[8]:$index}
                app_pid=${app_tokens[9]}
                echo "<$f_name> $app_name $app_pid"
                kill -9 $app_pid
                echo "<$f_name>Process is terminated."
        fi

fi
