#!/bin/bash

Volumep() {
    amixer -D pulse sset Master 5%+
}

Volumem() {
    amixer -D pulse sset Master 5%-
}

SetVolume() {
    amixer -D pulse sset Master $1%
}

Volume() {
    amixer -D pulse sget Master
}

VolumeMute() {
    amixer -D pulse sget Master toggle
}

SwitchAudio()###USE###
{

    source ${HOME}/bashscripts/bashEchoSP
    
    sink1=(`pactl list sinks | grep "Sink #" | awk '{ print $2}' | sed -e "s^#^^g"`)
    sink2=(`pactl list sinks | grep "Name: " | awk '{ print $2}'`)

    sinkInput1=(`pacmd list-sink-inputs | grep "index:" | sed -e "s^    index: ^^g"`)
    sinkInput2=(`pacmd list-sink-inputs | grep "application.process.binary = " | sed -e "s^application.process.binary = ^^g"`)

    if [ -z $@ ]
    then
	
	PM 5 "******** Available Sinks (command line inputs) ********"

	iter2=0
	for iter in ${sink1[*]}
	do
	    PM 5 "$iter2" 6 "${sink2[$iter2]}"
	    ((iter2++))
	done

	PM 5 "Extra input options"

	PM 5 "sinkinput" 7 "List available sink inputs"
	
    elif [ "$1" == "sinkinput" ]
    then

	PM 12 "******** Sinks Inputs (sources) ********"
	iter2=0
	for iter in ${sinkInput1[*]}
	do
	    PM 4 "$iter2" 11 "${sinkInput2[$iter2]}"
	    ((iter2++))
	done

    elif [[ $1 =~ ^[0-9]+$ ]]
    then
	#sinkchg=0
	#echo "Switch to which sink?"
	#read sinkchg

	for i in ${sinkInput1[*]}
	do
	    if [ "$i" != "" ] 
	    then
		#echo "pactl move-sink-input $i $sinkChgName"
		pactl move-sink-input $i ${sink1[$1]}
	    fi
	done

	#echo "pacmd set-default-sink $sinkChgName"
	pacmd set-default-sink ${sink2[$1]}

    else
	PM 0 "Input not reconzied"
    fi
    
}
