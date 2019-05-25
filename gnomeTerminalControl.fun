#!/bin/bash

# see: bash command `gconf-editor` apps > gnome terminal > profiles > Default to get keys (things to set and get)

GnomeTerminalChangeBold() {
    if [ "$#" -gt "0" ]
    then
	current="$1"
    else
	current=`gconftool-2 --get /apps/gnome-terminal/profiles/Default/allow_bold`
    fi
    if [ "$current" = "false" ]
    then
	gconftool-2 --set /apps/gnome-terminal/profiles/Default/allow_bold --type=bool true
    else
	gconftool-2 --set /apps/gnome-terminal/profiles/Default/allow_bold --type=bool false
    fi
}

GnomeTerminalChangeToLight() {
    #dconf list /org/gnome/terminal/legacy/profiles:/ #get profile
    #dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/background-color "'#FFFFF7B898BE'"
    profile=`gsettings get org.gnome.Terminal.ProfilesList default | sed -e "s^'^^g"`
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" background-color "#FFFFF7B898BE"
    #gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" foreground-color "#000000"
    
   alias e='env TERM=xterm-256color emacs -nw -q -l ${HOME}/Lynx/emacs_init2'
    export GREP_COLOR='1;37;40'
    if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto -I "*~"'
	#alias ls='ls --color=auto'
	# SEE: http://www.bigsoft.co.uk/blog/index.php/2008/04/11/configuring-ls_colors 
	AJSLSCOLORS_DIRECTORY="di=1;4;90" 
	AJSLSCOLORS_FILE="0;35" 
	AJSLSCOLORS_LINK="1;31" 
	AJSLSCOLORS_EXE="1;31"  
	AJSLSCOLORS_C='*.C=1;90'
	AJSLSCOLORS_CXX1='*.cxx=1;90'  
	AJSLSCOLORS_CXX2='*.cc=1;90'
	AJSLSCOLORS_H='*.h=1;90'
	AJSLSCOLORS_HH='*.hh=1;90'
	AJSLSCOLORS_MK='*.mk=1;90'
	AJSLSCOLORS_SKIP='*~=8'
	LS_COLORS="$AJSLSCOLORS_DIRECTORY:fi=$AJSLSCOLORS_FILE:ln=$AJSLSCOLORS_LINK:ex=$AJSLSCOLORS_EXE:$AJSLSCOLORS_C:$AJSLSCOLORS_CXX1:$AJSLSCOLORS_CXX2:$AJSLSCOLORS_H:$AJSLSCOLORS_HH:$AJSLSCOLORS_MK:$AJSLSCOLORS_SKIP" 
	#  
	#alias dir='dir --color=auto' 
	#alias vdir='vdir --color=auto'   
	
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'  
	alias egrep='egrep --color=auto'  
    fi
    if [[ $- == *i* ]]; then
	PS1="\[$(tput setaf 67)\]\[$(tput bold)\][\@] \[$(tput setaf 47)\]<<\[$(tput setaf 167)\]${HOSTNAME%%.*}\[$(tput setaf 47)\]>> \[$(tput setaf 65)\] \w $ \[$(tput setaf 232)\]"
    fi
}

GnomeTerminalChangeToDark() {
    #dconf list /org/gnome/terminal/legacy/profiles:/ #get profile
    #dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/background-color "'#FFFFF7B898BE'"
    profile=`gsettings get org.gnome.Terminal.ProfilesList default | sed -e "s^'^^g"`
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" background-color "#000000"
    #gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" foreground-color "#000000"
    
    alias e='env TERM=xterm-256color emacs -nw -q -l ${HOME}/Lynx/emacs_init1'
    if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto -I "*~"'
	#alias ls='ls --color=auto'
	# SEE: http://www.bigsoft.co.uk/blog/index.php/2008/04/11/configuring-ls_colors
	AJSLSCOLORS_DIRECTORY="di=1;4;38;5;133"
	AJSLSCOLORS_FILE="0;38;5;203"
	AJSLSCOLORS_LINK="0;38;5;83"
	AJSLSCOLORS_EXE="0;38;5;83"
	AJSLSCOLORS_C='*.C=0;38;5;203'
	AJSLSCOLORS_CXX1='*.cxx=0;38;5;203'
	AJSLSCOLORS_CXX2='*.cc=0;38;5;203'
	AJSLSCOLORS_H='*.h=0;38;5;203'
	AJSLSCOLORS_HH='*.hh=0;38;5;203'
	AJSLSCOLORS_MK='*.mk=0;38;5;203'
	AJSLSCOLORS_SKIP='*~=8'
	LS_COLORS="$AJSLSCOLORS_DIRECTORY:fi=$AJSLSCOLORS_FILE:ln=$AJSLSCOLORS_LINK:ex=$AJSLSCOLORS_EXE:$AJSLSCOLORS_C:$AJSLSCOLORS_CXX1:$AJSLSCOLORS_CXX2:$AJSLSCOLORS_H:$AJSLSCOLORS_HH:$AJSLSCOLORS_MK:$AJSLSCOLORS_SKIP"
	#
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'
	
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
    fi
    if [[ $- == *i* ]]; then
	PS1="\[$(tput setaf 67)\]\[$(tput bold)\][\@] \[$(tput setaf 47)\]<<\[$(tput setaf 167)\]${HOSTNAME%%.*}\[$(tput setaf 47)\]>> \[$(tput setaf 65)\] \w $ \[$(tput setaf 36)\]"
    fi
}

ChangeAllTerminals() {
terms=`ps axno user,tty | awk '$1 >= 1000 && $1 < 65530 && $2 != "?"' | sort -u | awk '{print $2}'`
for iterm in $terms
do
    ttyecho -n /dev/$iterm $1
done
}

GnomeTerminalChangeColor()###USE###
{
    if [ "$#" -gt "0" ]
    then
	currentname="$1"
        if [ "$currentname" = "l" ]
	then
	    echo "Change to Light"
	    ChangeAllTerminals GnomeTerminalChangeToLight
	else 
	    echo "Change to Dark"
	    ChangeAllTerminals GnomeTerminalChangeToDark
	fi
    else
	#current=`gsettings get "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" background-color`
	if [ "$BRIGHT_ENV" = "0" ]
	then
	    echo "Change to Light"
	    ChangeAllTerminals GnomeTerminalChangeToLight
	    ChangeAllTerminals GnomeTerminalChangeBrightnessVariableLight
	    ChangeAllTerminals GnomeTerminalUpdateBrightnessVariable1
	    cat ${HOME}/BrightEnv.env | sed -e "s^BRIGHT_ENV=.*^BRIGHT_ENV=1^g" > ${HOME}/tempfile
	    mv ${HOME}/Lynx/tempfile ${HOME}/Lynx/BrightEnv.env
	else 
	    echo "Change to Dark"
	    ChangeAllTerminals GnomeTerminalChangeToDark
	    ChangeAllTerminals GnomeTerminalChangeBrightnessVariableDark
	    ChangeAllTerminals GnomeTerminalUpdateBrightnessVariable1
	    cat ${HOME}/BrightEnv.env | sed -e "s^BRIGHT_ENV=.*^BRIGHT_ENV=0^g" > ${HOME}/tempfile
	    mv ${HOME}/Lynx/tempfile ${HOME}/Lynx/BrightEnv.env
	fi
    fi
    
}

GnomeTerminalChangeBrightnessVariableLight() {
    export BRIGHT_ENV=1
}

GnomeTerminalChangeBrightnessVariableDark() {
    export BRIGHT_ENV=0
}

GnomeTerminalUpdateBrightnessVariable1() {
    alias LogW="ssh -Y -t aschultz@pub.icecube.wisc.edu 'export BRIGHT_ENV=$BRIGHT_ENV;bash -l'"
}

GetFontValue() {
    fontval=0
    if [ "$#" = "0" ]
    then
	echo "NEED INPUT to get font value"
	exit
    else
	if [ "$1" = 'Plasmatic 11' ]
	then
	    fontval=1
	elif [ "$1" = 'NovaMono 11' ]
	then
	    fontval=2
	elif [ "$1" = 'Merchant Copy Doublesize 9' ]
	then
	    fontval=3
	elif [ "$1" = 'ASFont 11' ]
	then
	    fontval=4
	else
	    fontval=0
	fi
    fi
    echo $fontval
}

GnomeTerminalChangeFont() {

    fonts[0]='Underwood Champion Bold Italic 11'
    fonts[1]='Plasmatic 11'
    fonts[2]='NovaMono 11'
    fonts[3]='Merchant Copy Doublesize 9'
    fonts[4]='ASFont 11'

    font=`gconftool-2 --get /apps/gnome-terminal/profiles/Default/font`
    fontval=`GetFontValue "$font"`
    
    if [ "$fontval" = "4" ]
    then
	fontval=0
    else
	((fontval++))
    fi

    echo "${fonts[$fontval]}"
    gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type=string "${fonts[$fontval]}"

}

SetKBR() {
    xset r rate 250 50
}
