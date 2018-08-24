#!/bin/bash

QQ()###USE###
{
    killall -9 chrome skype wicd-client
}

Q()###USE###
{
    /home/dulain/bashscripts/killAllTerminals ; QQ ; /home/dulain/bashscripts/ShutDown
    #sudo poweroff
    #/home/dulain/ShutDown_Script.sh
}

RR()###USE###
{
    QQ ; /home/dulain/bashscripts/Reboot
    #sudo poweroff
    #/home/dulain/ShutDown_Script.sh
}

r()###USE###
{
    reset
}

