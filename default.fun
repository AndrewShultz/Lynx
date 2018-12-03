#!/bin/bash

PI()###USE###
{
    echo "4*a(1)" | bc -l
}

q()###USE###
{
exit 1
}

KillScreens(){
screen -ls | grep tached | awk -F" " '{print $1}' | xargs -I{} screen -X -S {} kill
}

M()###USE###
{
    deep=`/home/dulain/Schwermetall/getUseLibraries $1.C`
    cat /home/dulain/Schwermetall/Maker.mk | sed -e "s^((((PROGRAM))))^$1^g" > tmake.mk
    cat tmake.mk | sed -e "s^((((LIBRARIES))))^$deep^g" > tmake2.mk
    make -f tmake2.mk
    #if [ -f "tmake.mk" ] ; then rm tmake.mk ; fi
    #if [ -f "tmake2.mk" ] ; then rm tmake2.mk ; fi
}

AM()###USE###
{
    deep=`/home/dulain/Schwermetall/getUseLibraries $1.C`
    cat /home/dulain/Schwermetall/Maker.mk | sed -e "s^((((PROGRAM))))^$1^g" > tmake.mk
    cat tmake.mk | sed -e "s^((((LIBRARIES))))^$deep^g" > tmake2.mk
    make --always-make -f tmake2.mk
    if [ -f "tmake.mk" ] ; then rm tmake.mk ; fi
    if [ -f "tmake2.mk" ] ; then rm tmake2.mk ; fi
}

CM()###USE###
{
    deep=`/home/dulain/Schwermetall/getUseLibraries $1.C`
    cat /home/dulain/Schwermetall/Maker.mk | sed -e "s^((((PROGRAM))))^$1^g" > tmake.mk
    cat tmake.mk | sed -e "s^((((LIBRARIES))))^$deep^g" > tmake2.mk
    make -f tmake2.mk clean
    make -f tmake2.mk
    if [ -f "tmake.mk" ] ; then rm tmake.mk ; fi
    if [ -f "tmake2.mk" ] ; then rm tmake2.mk ; fi
}

ML()###USE###
{
    deep=`/home/dulain/Schwermetall/getUseLibraries $1.h`
    cat /home/dulain/Schwermetall/LibMaker.mk | sed -e "s^((((PROGRAM))))^$1^g" > tmake.mk
    cat tmake.mk | sed -e "s^((((LIBRARIES))))^$deep^g" > tmake2.mk
    make -f tmake2.mk
    if [ -f "tmake.mk" ] ; then rm tmake.mk ; fi
    if [ -f "tmake2.mk" ] ; then rm tmake2.mk ; fi
}

AML()###USE###
{
    deep=`/home/dulain/Schwermetall/getUseLibraries $1.h`
    cat /home/dulain/Schwermetall/LibMaker.mk | sed -e "s^((((PROGRAM))))^$1^g" > tmake.mk
    cat tmake.mk | sed -e "s^((((LIBRARIES))))^$deep^g" > tmake2.mk
    make --always-make -f tmake2.mk
    if [ -f "tmake.mk" ] ; then rm tmake.mk ; fi
    if [ -f "tmake2.mk" ] ; then rm tmake2.mk ; fi
}

CML()###USE###
{
    deep=`/home/dulain/Schwermetall/getUseLibraries $1.h`
    cat /home/dulain/Schwermetall/LibMaker.mk | sed -e "s^((((PROGRAM))))^$1^g" > tmake.mk
    cat tmake.mk | sed -e "s^((((LIBRARIES))))^$deep^g" > tmake2.mk
    make -f tmake2.mk clean
    make -f tmake2.mk
    if [ -f "tmake.mk" ] ; then rm tmake.mk ; fi
    if [ -f "tmake2.mk" ] ; then rm tmake2.mk ; fi
}

Calculate() {
    awk "BEGIN { print "$*" }"
}

shrinkPDF()###USE###
{
    file=$1
    file=${file%.*}
    file=${file##*/}
    pdf2ps ${file}.pdf
    ps2pdf ${file}.ps
    rm ${file}.ps
}

AvailSpace() {
    space=`df -h | awk '{print $5}' | grep % | grep -v Use | sort -n | tail -1 | cut -d "%" -f1 -`
    case $space in
	[1-6]*)
	    Message="Disk is ${space}% full"
	    ;;
	[7-8]*)
	    Message="Start thinking about cleaning out some stuff.  There's a partition that is $space % full."
	    ;;
	9[1-8])
	    Message="Better hurry with that new disk...  One partition is $space % full."
	    ;;
	99)
	    Message="I'm drowning here!  There's a partition at $space %!"
	    ;;
	*)
	    Message="I seem to be running with an nonexistent amount of disk space..."
	    ;;
    esac
    echo $Message
}

RemountWithReadWritePerm() {
    sudo mount -o remount,rw $1
}

CountTopLevelFiles()###USE###
{
    for i in $(find $(pwd) -maxdepth 1 -type d | sort); do echo -e "$(find "$i" | wc -l) files \t $(du -hs "$i"): $(readlink -f "$i")"; done | sort -nr
}

ListAllFunctionsUpdate2()###USE###
{

    LAFoutfile=${HOME}/bashscripts/allFunctions.list
    if [ -f "${LAFoutfile}" ] ; then rm "${LAFoutfile}" ; fi

    #asHeader=$(tput setab 227)$(tput setaf 232)
    #asEntry=$(tput setab 88)$(tput setaf 83)
    #asUseEntry=$(tput setab 208)$(tput setaf 21)
    asHeader=$(tput setaf 228)
    asHeader2=$(tput setab 228)
    asEntry=$(tput setaf 168)
    asEntry2=$(tput setab 168)
    asUseEntry=$(tput setaf 71)
    asUseEntry2=$(tput setab 71)
    asAlias=$(tput setaf 87)
    asAlias2=$(tput setab 87)
    
    files=(`cat ~/.bashrc | grep "source" | sed -e "s^.*source^^g"`)
    
    searchterm="("
    searchterm+=")"
    
    for file in ${files[*]}
    do
	ifile=`echo "$file" | sed -e "s^.*/^^g"`
	iifile=`echo "$file" | sed -e 's^${HOME}^HOME^g' -e "s^HOME^${HOME}^g"`
	echo -e "${asHeader2}\t\033[0m${asHeader} ${ifile}\033[0m" >> "${LAFoutfile}"
	#funs=(`grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' $file | sed -e "s^(^^g" -e "s^)^^g" -e "s^{^^g"`)
	funs=(`grep $searchterm "$iifile" | sed -e "s^(^^g" -e "s^)^^g" -e "s^{^^g"`)
	#alia=(`grep -v '#alias' $file | grep 'alias' | sed -e "s^alias^^g" -e "s^=.*^^g"`)
	alia=(`grep -P '^alias' "$iifile" | sed -e "s^alias^^g" -e "s^=.*^^g"`)
	
	mess1=""
	mess2=""

	for ali in ${alia[*]}
	do
	    #innerali=`echo "$ali" | sed -e "s^al" && findRes=1 || findRes=0
		mess1+="${asAlias2}\t\t\t\t\033[0m"
		mess1+="${asAlias}"
		mess1+=" $ali\033[0m\n"
		#mess1+=
	done
	
	for fun in ${funs[*]}
	do
	    echo "$fun" | grep -q "###USE###" && findRes=1 || findRes=0
	    if [ $findRes -eq 1 ]
	    then
		tfun=`echo $fun | sed -e "s^###USE###^^g"`
		mess1+="${asUseEntry2}\t\t\t\t\033[0m"
		mess1+="${asUseEntry}"
		mess1+=" $tfun\033[0m\n"
	    else
		mess2+="${asEntry2}\t\t\t\t\t\t\t\t\033[0m"
		mess2+="${asEntry}"
		mess2+=" $fun\033[0m\n"
	    fi
	    
	done
	    
	echo -ne "$mess1" >> "${LAFoutfile}"
	echo -ne "$mess2" >> "${LAFoutfile}"
	
    done

    echo "" >> "${LAFoutfile}"
    echo "" >> "${LAFoutfile}"
    echo "---KEY---" >> "${LAFoutfile}"
    echo -e "${asHeader2}\t\033[0m${asHeader} FILE\033[0m" >> "${LAFoutfile}"
    echo -e "${asAlias2}\t\t\t\t\033[0m${asAlias} ALIAS \033[0m" >> "${LAFoutfile}"
    echo -e "${asUseEntry2}\t\t\t\t\033[0m${asUseEntry} Command line level FUNCTION \033[0m" >> "${LAFoutfile}"
    echo -e "${asEntry2}\t\t\t\t\t\t\t\t\033[0m${asEntry} Script level FUNCTION \033[0m" >> "${LAFoutfile}"
        
}

ListAllFunctionsNiceUpdate()###USE###
{

    LAFNoutfile=${HOME}/bashscripts/allFunctions.nicelist
    if [ -f "${LAFNoutfile}" ] ; then rm "${LAFNoutfile}" ; fi

    #asHeader=$(tput setab 227)$(tput setaf 232)
    #asEntry=$(tput setab 88)$(tput setaf 83)
    #asUseEntry=$(tput setab 208)$(tput setaf 21)
    asHeader=$(tput setaf 228)
    asHeader2=$(tput setab 228)
    asEntry=$(tput setaf 168)
    asEntry2=$(tput setab 168)
    asUseEntry=$(tput setaf 71)
    asUseEntry2=$(tput setab 71)
    asAlias=$(tput setaf 87)
    asAlias2=$(tput setab 87)
    mess1=""
    mess2=""
    mess3=""
    
    files=(`cat ~/.bashrc | grep "source" | sed -e "s^.*source^^g"`)
    
    searchterm="("
    searchterm+=")"

    totali=""
    totfun=""
    totfun2=""
    
    for file in ${files[*]}
    do
	ifile=`echo "$file" | sed -e "s^.*/^^g"`
	iifile=`echo "$file" | sed -e 's^${HOME}^HOME^g' -e "s^HOME^${HOME}^g"`
	echo -e "${asHeader2}\t\033[0m${asHeader} ${ifile}\033[0m" >> "${LAFNoutfile}"
	funs=(`grep $searchterm "$iifile" | sed -e "s^(^^g" -e "s^)^^g" -e "s^{^^g"`)
	alia=(`grep -P '^alias' "$iifile" | sed -e "s^alias^^g" -e "s^=.*^^g"`)

	for ali in ${alia[*]}
	do
	    totali+="${ali} "
	done

	for fun in ${funs[*]}
	do
	    echo "$fun" | grep -q "###USE###" && findRes=1 || findRes=0
	    if [ $findRes -eq 1 ]
	    then
		tfun=`echo $fun | sed -e "s^###USE###^^g"`
		totfun+="${tfun} "
	    else
		totfun2+="${fun} "
	    fi
	    
	done

    done

    stotali=(`echo "$totali" | sed -e "s^ ^\n^g" | sort`)
    stotfun=(`echo "$totfun" | sed -e "s^ ^\n^g" | sort`)
    stotfun2=(`echo "$totfun2" | sed -e "s^ ^\n^g" | sort`)
    
    for ali in ${stotali[*]}
    do
	mess1+="${asAlias2}\t\t\t\t\033[0m"
	mess1+="${asAlias}"
	mess1+=" $ali\033[0m\n"
    done
	
    for fun in ${stotfun[*]}
    do
	mess2+="${asUseEntry2}\t\t\t\t\033[0m"
	mess2+="${asUseEntry}"
	mess2+=" $fun\033[0m\n"
    done

    for fun in ${stotfun2[*]}
    do
	mess3+="${asEntry2}\t\t\t\t\t\t\t\t\033[0m"
	mess3+="${asEntry}"
	mess3+=" $fun\033[0m\n"
    done
    
    echo -ne "$mess1" >> "${LAFNoutfile}"
    echo -ne "$mess2" >> "${LAFNoutfile}"
    echo -ne "$mess3" >> "${LAFNoutfile}"
	
    echo "" >> "${LAFNoutfile}"
    echo "" >> "${LAFNoutfile}"
    echo "---KEY---" >> "${LAFNoutfile}"
    echo -e "${asHeader2}\t\033[0m${asHeader} FILE\033[0m" >> "${LAFNoutfile}"
    echo -e "${asAlias2}\t\t\t\t\033[0m${asAlias} ALIAS \033[0m" >> "${LAFNoutfile}"
    echo -e "${asUseEntry2}\t\t\t\t\033[0m${asUseEntry} Command line level FUNCTION \033[0m" >> "${LAFNoutfile}"
    echo -e "${asEntry2}\t\t\t\t\t\t\t\t\033[0m${asEntry} Script level FUNCTION \033[0m" >> "${LAFNoutfile}"
        
}

ListAllFunctions()###USE###
{

    LAFoutfile=${HOME}/bashscripts/allFunctions.list
    cat "$LAFoutfile"
    
}

ListAllFunctionsNice()###USE###
{

    LAFNoutfile=${HOME}/bashscripts/allFunctions.nicelist
    cat "$LAFNoutfile"
    
}

ListAllFunctionsUpdate()###USE###
{
    ListAllFunctionsNiceUpdate
    ListAllFunctionsUpdate2
}

reduceJPGFileSize()###USE###
{
    convert $1 -resize 50% $1
}

ptpecho()###USE###
{
    out=$(echo `pwd`"/$1")
    echo "$out"
    printf "$out" | xclip -selection clipboard
}

BufferCacheClearance()###USE###
{
    sudo /home/dulain/bashscripts/CacheClearance/clearcache
}

ZipIt()###USE###
{
    if [ -z $@ ] || [ ! -d $1 ]
    then
	echo "The input should be a directory"
    else
	zip z${1}.zip ${1}/*
    fi

    
    
}
