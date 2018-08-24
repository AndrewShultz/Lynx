#!/bin/bash

pmcolors=()

pmcolors[${#pmcolors[*]}]="\033[38;5;196m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;82m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;201m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;165m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;168m\033[48;5;16m"

pmcolors[${#pmcolors[*]}]="\033[38;5;204m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;211m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;99m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;27m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;33m\033[48;5;16m"

pmcolors[${#pmcolors[*]}]="\033[38;5;37m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;50m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;72m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;120m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;105m\033[48;5;16m"

pmcolors[${#pmcolors[*]}]="\033[38;5;142m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;130m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;172m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;208m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;214m\033[48;5;16m"

pmcolors[${#pmcolors[*]}]="\033[38;5;220m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;226m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;179m\033[48;5;16m"
pmcolors[${#pmcolors[*]}]="\033[38;5;203m\033[48;5;16m"


PM()###USE###
{

    re='^[0-9]+$'
    
    
    if [ $# -gt 1 ] ; then
	if ! [[ $2 =~ $re ]] ; then
	    printf "${pmcolors[$1]}$2$clr "
	else
	    printf "${pmcolors[$1]}%7s      $clr " "$2"
	fi
    fi

    if [ $# -gt 3 ] ; then
	if ! [[ $4 =~ $re ]] ; then
	    printf "${pmcolors[$3]} $4 $clr "
	else	
	    printf "${pmcolors[$3]}%7s      $clr " "$4"
	fi
    fi

    if [ $# -gt 5 ] ; then
	if ! [[ $6 =~ $re ]] ; then
	    printf "${pmcolors[$5]} $6 $clr "
	else	
	    printf "${pmcolors[$5]}%7s      $clr " "$6"
	fi
    fi

    if [ $# -gt 7 ] ; then
	if ! [[ $8 =~ $re ]] ; then
	    printf "${pmcolors[$7]} $8 $clr "
	else	
	    printf "${pmcolors[$7]}%7s      $clr " "$8"
	fi
    fi

    if [ $# -gt 9 ] ; then
	if ! [[ $10 =~ $re ]] ; then
	    printf "${pmcolors[$9]} $10 $clr "
	else	
	    printf "${pmcolors[$9]}%7s      $clr " "$10"
	fi
    fi

    printf "\n\n"
    
}

ListPMColors()###USE###
{

    j=0
    for i in ${pmcolors[*]}
    do
	printf "$i%5s TEST $clr\n" "$j"
	((j++))
    done

}

echoload()###USE###
{
# echoload percent  
# echoload percent message 
# echoload percent color message 
    if [ -t 1 ]; then
	#ncol=$(tput cols)
	nlin=$(tput lines)
	colLen=`awk "BEGIN{ printf $(tput cols)-7 }"`
	per=`awk "BEGIN{ printf (${1}/100.0)*$colLen  }" | cut -c 1-4` ; ndots=`echo "$per" | awk -v FS='.' '{printf $1}'`
	per2=`echo "$1" | cut -c 1-5`;mess=`printf "%5s[" "$per2"`;mess+="$(tput setab 47)";for i in `seq 1 1 $ndots` ; do mess+=" " ; done 
	mess+="$(tput setab 197)";mndots=`awk "BEGIN{ printf $colLen-1 }"`;for i in `seq $ndots 1 $mndots` ; do mess+=" " ; done
	if [ $# -eq 2 ] ; then printf "$2\n\n\033[1A$(tput il1)" ; fi
	if [ $# -eq 3 ] ; then printf "$2$3\033[0m\n\n\033[1A$(tput il1)" ; fi
	if [ `echo $per2'>='100.0 | bc -l` -eq 1 ] ; then echo -ne "\033[s\033[$nlin;0H\033[K\033[0m\033[u" ; echo ;
	else echo -ne "\033[s\033[$nlin;0H\033[K${mess}\033[0m]\033[u" ; fi
    else
	if [ $# -eq 2 ] ; then printf "$2\n" ; fi
	if [ $# -eq 3 ] ; then printf "$2$3\033[0m\n" ; fi
    fi

}

echomess()###USE###
{
    if [ $# -eq 2 ] ; then echo -e "$1$2\033[0m" ;  else echo "$1" ; fi
}
