#!/bin/bash

WordCount()###USE###
{
    WORDS=`less $1`
    EDITWORDS=`echo "$WORDS" | sed -e "s^,^^g" -e "s^-^^g" -e "s^(^^g" -e "s^)^^g" -e "s^:^^g" -e "s^;^^g"`
    CNT=0
    for word in $EDITWORDS
    do
	((CNT++))
    done
    echo "$CNT"
}

GoToBeamer()###USE###
{
    beam=`kpsewhich beamer.cls`
    beam=${beam%/*}
    cd ${beam}
}

ts-switchpages()###USE###
{

    if [ $# -lt 2 ] ; then return ; fi

    f1=$1
    f2=$2
    tfile1=temp1.tex
    mv $f1 $tfile1
    mv $f2 $f1
    mv $tfile1 $f2

}

ts-update()###USE###
{

    tempfile=temp.tex
    Pwd=`pwd`
    file=`echo $Pwd | sed -e "s^.*/^^g"`.tex
    cat $file > $tempfile
    incs=(`cat $file | grep "\include{"`)
    page=1
    pages=
    summary=
    backupdir=".backup"

    if [ ! -d "$backupdir" ] ; then mkdir "$backupdir" ; fi

    for inc in ${incs[*]}
    do
	if [[ ! $inc == %* ]]
	then
	    sed -i "/$inc/d" $tempfile
	    tran=`echo "$inc" | sed -e "s^.*include{^^g" -e "s^}^^g"`
	    cp "${tran}.tex" "$backupdir/${tran}.tex"
	    cp ${tran}.tex temp${page}.tex
	    summary+="${tran}.tex --> p${page}.tex \n"
	    pages[$page]=$tran
	    ((page++))
	fi
    done

    #PM 1 "$file"
    echo -e "\033[38;5;82m\033[48;5;16m$file"
    cp "$file" "$backupdir/$file"

    #echo "${pages[*]}"
    #echo "${#pages[*]}"

    echo -e "$summary"
    #PM 5 "These changes will be made, proceed? (y/n/q)"
    echo -e "\033[38;5;82m\033[48;5;16mThese changes will be made, proceed? (y/n/q)"


    while true ; do
	read -n1 -s yn
	case $yn in
	    [Yy]* )
		PM 1 "Proceeding"
		break;;
	    [Nn]* )
		PM 0 "Quitting"
		return 1;;
	    [Qq]* )
		PM 0 "Quitting"
		return 1;;
	    * )
		"Please enter (y/n/q)";;
	esac
    done

    #PM 6 "Executing changes"
    echo -e "\033[38;5;211m\033[48;5;16mExecuting changes"

    sed -i "/end{document}/d" $tempfile

    page=1
    for pag in ${pages[*]}
    do
	mv temp${page}.tex p${page}.tex
       	echo "\\include{p${page}}" >> $tempfile
	((page++))
    done

    echo "\\end{document}" >> $tempfile

    cat $tempfile > $file
    if [ -f "$tempfile" ] ; then rm "$tempfile" ; fi

}

ts-start2() {

    Pwd=`pwd`
    wd=$Pwd/$1
    num=`echo "$wd" | grep -o "/" | wc -l`
    file=`echo $wd | cut -d"/" -f${num}`
    openfiles="${file}.tex"

    if [ -f "${file}.tex" ]
    then
	files=(`cat "${file}.tex" | grep "input{\|include{" | sed -e "s^input{^^g" -e "s^include{^^g" -e "s^}^^g" -e "s^[\]^^g"`)
    fi

    if [ -z "$files" ]
    then

	cnt=0
	temples=(`ls ${HOME}/LaTeXDocs/usercode/templates/*`)
	echo "Empty project... RALLYING..."
	echo "Pick project type:"

	for ite in ${temples[*]}
	do

	    temple=`echo $ite | sed -e "s^.tex^^g" -e "s^${HOME}/LaTeXDocs/usercode/templates/^^g"`
	    echo "$cnt: $temple"
	    ((cnt++))

	done

	read cho

	cp "${temples[$cho]}" "./${file}.tex"
	echo "" > p1.tex
	echo "% !TeX root = ${file}" >> p1.tex
	echo "" >> p1.tex
	echo "\asframe{Introduction}{" >> p1.tex
	echo "{\let\clearpage\relax \chapter{Introduction}}" >> p1.tex
	openfiles+=" p1.tex"

    else

	for ifile in ${files[*]}
	do
	    openfiles+=" $ifile.tex"
	done

    fi

    texstudio --start-always $openfiles

}

ts-start()###USE###
{

    output=(`grep -m1 -l -d skip "documentclass" ./*`)
    if [[ "${#output[*]}" > "1" ]];
    then
	echo "Cannot determine main file:"
	for ioutput in "${output[@]}"
	do
	    printf "%s\n" "${ioutput%%:*}"
	done
	return
    fi
    mainfile="${output%%:*}"
    openfiles="$mainfile"

    if [ -f "$mainfile" ]
    then
	echo "MainFile: $mainfile"
	files=(`grep "\include{" "$mainfile"`)
	#echo "${files[*]}"
	for file in "${files[@]}"
	do
	    #echo ${file} | sed -e "s^.*{^^g" -e "s^}.*^^g"
	    openfile=`echo ${file} | sed -e "s^.*{^^g" -e "s^}.*^^g"`".tex"
	    if [ -f "$openfile" ]
	    then
		openfiles+=" $openfile"
	    fi

	done
    else

	cnt=0
	temples=(`ls ${HOME}/Lynx/LaTeX/Templates/*`)
	PM 0 "Empty project... RALLYING..."
	PM 0 "Pick project type:"

	for temple in "${temples[@]}"
	do

	    PM 1 "$cnt: ${temple##*/}"
	    ((cnt++))

	done

	read cho

	PM 0 "What should the main file be called?"
	read mainfilename

	cp "${temples[$cho]}" "./${mainfilename}.tex"
	openfiles="${mainfilename}.tex"
	
	if [[ "${temples[$cho]##*/}" == "GenericReport.tex" ]]
	then
	    cat "${HOME}/Lynx/LaTeX/Generic/intro.tex" | sed -e "s^???TITLE???^$mainfilename^g" > ./intro.tex
	    cp "${HOME}/Lynx/LaTeX/Generic/genericdocument.sty" ./
	    cp "${HOME}/Lynx/LaTeX/Generic/macros.sty" ./
	    cp "${HOME}/Lynx/LaTeX/Classes/ASReport.cls" ./
	    openfiles+=" intro.tex"
	fi
	if [[ "${temples[$cho]##*/}" == "BeamerPresentation.tex" ]]
	then
	    cat "${HOME}/Lynx/LaTeX/Generic/p1.tex" | sed -e "s^???TITLE???^$mainfilename^g" > ./p1.tex
	    cp "${HOME}/Lynx/LaTeX/Generic/genericpresentation.sty" ./
	    cp "${HOME}/Lynx/LaTeX/Generic/macros.sty" ./
	    openfiles+=" p1.tex"
	    #cp "${HOME}/Lynx/LaTeX/Generic/p1.tex" ./
	fi

	if [[ "${temples[$cho]##*/}" == "Simple.tex" ]]
	   then
	    cat "${HOME}/Lynx/LaTeX/Generic/intro.tex" | sed -e "s^???TITLE???^$mainfilename^g" > ./intro.tex
	    cp "${HOME}/Lynx/LaTeX/Generic/genericdocument.sty" ./
	fi
	
    fi

    #echo "Opening: $openfiles"
    texstudio --start-always $openfiles
    
}
