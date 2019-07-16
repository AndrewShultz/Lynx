#!/bin/bash

CONVERT_SVG_2_PDF()###USE###
{
rsvg-convert -f pdf -o $1.pdf $1.svg
}

#Copying stuff to smart phone. Use `jmtpfs ~/mount/` to mount. (sudo apt-get install jmtpfs)
CopyFromTo()###USE###
{

    if [[ "$#" < 2 ]] ; then echo "Need input directory and output directory" ; return ; fi

    if [[ ! -d $1 ]] ; then echo "Argument 1 is not a directory" ; return ; fi
    if [[ ! -d $2 ]] ; then echo "Argument 2 is not a directory" ; return ; fi
    
    #files=(`find $1/ -name "*"`)

    cd $1
    
    filecnt=(`ls | sed -e "s^.*^file^g"`)
    filecnt=${#filecnt[@]}
    movedir="$2/"

    #"${#files[*]}"
    ifile=0
    
    echo "File cnt: $filecnt"

    for file in *
    do
	((ifile++))
	echoload `awk "BEGIN{ printf $ifile/$filecnt*100}"` $asGreen "Copying ${file}"
	cp "${file}" "$movedir"
    done
    
}
