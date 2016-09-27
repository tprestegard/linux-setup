#! /usr/bin/env bash
###########################

# valid time limit for cert. (HH:MM)
user="tanner.prestegard"

#source ~/ldg-4.8/setup.sh

x=`grid-proxy-info -timeleft`

if [[ $(($x - 3600*8)) -le 0 ]] || [[ -z "$x" ]];
then
    ligo-proxy-init $user
fi

# EOF