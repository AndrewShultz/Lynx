#!/bin/bash

echoload() {
    if [ -t 1 ]; then
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


MusicMessoremConvert() {
    P_W_D=`pwd`
    cd ~/Music/Rename/
    for i in *.m4a; do
	#NEWFILE=`echo $i | sed 's^(.*)^^g' | sed 's^ .m4a^.m4a^g' | sed "s^ '^ ^g" | sed "s^'.^.^g"`
	NEWFILENAME=`echo $i | sed 's^.m4a^.mp3^g'`
	NEWFILENAME=`echo "$NEWFILENAME" | sed 's/\b\([[:alpha:]]\)\([[:alpha:]]*\)\b/\u\1\L\2/g'`
	echo "$i -> $NEWFILENAME"
	ffmpeg -i "$i" "$NEWFILENAME"
    done
    rm *.m4a
    cd $P_W_D
}

MusicMessorem()###USE###
{
    #    while IFS='' read -r line || [[ -n "$line" ]]; do
    #	newline=`echo "$line" | sed -e "s^&list.*^^g"`
    #	newline=`echo "$newline" | sed -e "s^&index.*^^g"`
    #	echo "$newline"
    #	youtube-dl -f 140 $newline -o /home/dulain/Music/Rename/"%(title)s.%(ext)s"
    #    done < "/home/dulain/Music/messorem.txt"
    #    MusicMessoremConvert
    
    #python /home/dulain/python/YouTubeDL/dler.py

    ${HOME}/Lynx/YouTubeDLer/YouTubeDLer
    
}

Renamerem() {
    P_W_D=`pwd`
    cd ~/Music/Rename/

    temprename=temp.txt
    if [ -f $temprename ] ; then rm $temprename ; fi

    oldnames=(*".mp3")
    cnt=${#oldnames[@]}
    cnt=`awk "BEGIN{ printf ${cnt}-1 }"`
    for iname in `seq 0 1 $cnt` ; do echo "${oldnames[$iname]}" >> $temprename ; done
    
    e $temprename
    newnames=
    readcnt=0
    
    while IFS= read -r line
    do
	newnames[$readcnt]="$line"
	((readcnt++))
    done < "$temprename"
    
    for iname in `seq 0 1 $cnt`
    do
    	mv "${oldnames[$iname]}" /home/dulain/Music/Messorem/"${newnames[$iname]}"
    done

    if [ -f "$temprename" ] ; then rm $temprename ; fi
    cd $P_W_D
}

HandleMusic()###USE###
{
    
    P_W_D=`pwd`
    cd ~/Music/Messorem/
    
    if [ $# -lt 1 ]
    then
	echo "USAGE OPTIONS (1 ARGUMENT ONLY):"
	echo "0: Move to mp3 player"
	echo "1: Move to usb stick"
	echo "2: Move to computer internal sd card"
	echo "3: Move to finished directory"
	cd $P_W_D
	return
    else
	option=$1
    fi

    allfilescnt=(`ls | sed -e "s^.*mp3^mp3^g"`)
    allfilescnt=${#allfilescnt[@]}
    ifile=0

    #echo "Current directory: `pwd`"
    #ls

    cmd=cp
    if [[ "$1" < "0" || "$1" > "3" ]] ; then echo "Not a valid option. " ; cd $P_W_D ; return ; fi
    if [[ "$1" == "0" ]] ; then	movedir='/media/dulain/Clip Sport/Music/NewMusic/' ; fi
    if [[ "$1" == "1" ]] ; then	movedir='/media/dulain/USB20FD/All Music/' ; fi
    if [[ "$1" == "2" ]] ; then	movedir='/media/dulain/9016-4EF8/Music/' ; fi
    if [[ "$1" == "3" ]] ; then	movedir='/home/dulain/Music/ToArchive/' ; cmd=mv ; fi

    echo "Command = $cmd"
    echo "End Directory = $movedir"

    if [ ! -d "$movedir" ]
    then
	echo "Directory doesn't exist..."
	cd $P_W_D
	return
    fi
    
    for file in *.mp3
    do
	if [ -f "${file}" ]
	then
	    ((ifile++))
	    echoload `awk "BEGIN{ printf $ifile/$allfilescnt*100}"` $asGreen "Copying ${file}"
	    $cmd "${file}" "$movedir"
	else
	    ((ifile++))
	    echoload `awk "BEGIN{ printf $ifile/${#allfiles[@]}*100}"` $asRed "File nonexistant: ${file}"
	fi
    done
    
    cd $P_W_D
    
}

PlayMusic()###USE###
{
    pldir=${HOME}/Music/Playlists
    #/home/dulain/bashscripts/playmusic2.sh && exit
    #/home/dulain/python/PlayMusic/playMusic.py $1
    file=`basename $1`
    if [ ! -f "${pldir}/${file}.txt" ]
    then
	Udpl $1
    fi

    #mplayer -shuffle -playlist ${pldir}/${file}.txt
    /home/dulain/PSoft/mplayer-transcribe-master/mplayer-transcribe ${pldir}/${file}.txt

}

Udpl()###USE###
{
    pldir=${HOME}/Music/Playlists
    if [ ! -d ${pldir} ] ; then mkdir -p ${pldir} ; fi
    if [ -z $1 ] ; then indir=`pwd` ; indirname=`basename ${indir}` ; else indir=`pwd`/$1 ; indirname=`basename ${indir}` ; fi
    if [ -z "$indirname" ] ; then echo "Trouble getting in directory name (make sure no ending front slash)" ; return 1 ; fi
    find ${indir}/ -name "*.mp3" > ${pldir}/${indirname}.txt   
}
