#!/bin/bash

#Create a colourful prompt
color_prompt=yes

#Put the path in the title, put the bash history number in yellow and the current path in green
PS1='\[\033]0;\w\a\]\[\033[32m\]\u@\h \[\033[33m\]\w\[\033[0m\]\$ '

#Make directories pink so they are easier to see
LS_COLORS='di=0;35';
export LS_COLORS

#Add colour output to some useful commands
alias ls="ls --color"
alias grep="grep --color"
alias repo="repo --time"

#Set up Java
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin

#Cache the output of the compiler to save time when compiling a file which has not been changed since the last compile
export USE_CCACHE=1

#Start in the build dir with the commands aliased
cd ~/android/system
source build/envsetup.sh
