#!/bin/bash

Stretch()###USE###
{
    gnome-terminal.real --tab --zoom=3.5 -e /home/dulain/bashscripts/Stretcher
}

Stretch2()###USE###
{

    stretch=30 #seconds to stretch
    pause=10 #seconds for rest
    reps=16 # number of stretches
    
    realstretch=`echo "${stretch}-3" | bc -l`
    realpause=`echo "${pause}-3" | bc -l`
    
    for j in `seq 1 1 ${reps}`
    do

	echo -e "\033[38;5;207m"
	for i in `seq 1 1 ${realpause}`
	do
	    echo "$i"
	    sleep 1
	done
	for i in `seq 1 1 3`
	do
	    echo `echo "${realpause}+$i" | bc -l`
	    aplay /home/dulain/Downloads/button-3.wav 1>/dev/null 2>/dev/null
	    sleep 1
	done
	aplay /home/dulain/Downloads/button-35.wav 1>/dev/null 2>/dev/null


	
	echo -e "\033[0m"
	echo "BEGIN !!!"
	echo "stretch $j of $reps"
	echo -e "\033[38;5;196m"


	
	for i in `seq 1 1 ${realstretch}`
	do
	    echo "$i"
	    sleep 1
	done
	for i in `seq 1 1 3`
	do
	    echo `echo "${realstretch}+$i" | bc -l`
	    aplay /home/dulain/Downloads/button-45.wav 1>/dev/null 2>/dev/null
	    sleep 1
	done
	aplay /home/dulain/Downloads/beep-02.wav 1>/dev/null 2>/dev/null
	echo "REST !!!"
		
	
    done
    
}
