#!/bin/bash
# Author: Matej Kastak
#         Matus Jasnicky
# Start date: 17.3.2019
# Modification of great bash config from:
# https://natelandau.com/my-mac-osx-bash_profile/
# ---------------------------------------------------------------------------
# Description:  This file holds all my BASH configurations and aliases
#
# Set the shell prompt
# export PS1="\[\e[01;31m\]\u\[\e[0m\]\[\e[00;37m\]@\h:\[\e[0m\]\[\e[00;36m\][\W]\[\e[0m\]\[\e[00;37m\]\\$ \[\e[0m\]"
export PS1="\[\e[32m\]\u\[\e[m\]@\h:\[\e[31m\][\[\e[m\]\W\[\e[31m\]]\[\e[m\]\\$ "

# Set Paths
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin:$PATH"

# Better yaourt colors
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

# Set default Editor
# If emacs is installed use that option otherwise select nano as default editor
if command -v emacsclient >/dev/null 2>&1; then
    export EDITOR="emacsclient -t"
else
    export EDITOR=/usr/bin/nano
fi

# Set default blocksize for ls, df, du
export BLOCKSIZE=1k

# export CLICOLOR=1
# export LSCOLORS=ExFxBxDxCxegedabagacad

# Bind TAB:menu-complete
complete -cf sudo
complete -cf man

# xhost +local:root > /dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Extract most know archives with one command
# Usage: ex <file>
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
    echo "'$1' is not a valid file"
    fi
}

################################################ COLOURS ###################################
# [[ $- != *i* ]] && return

# colors() {
#   local fgc bgc vals seq0

#   printf "Color escapes are %s\n" '\e[${value};...;${value}m'
#   printf "Values 30..37 are \e[33mforeground colors\e[m\n"
#   printf "Values 40..47 are \e[43mbackground colors\e[m\n"
#   printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

#   # foreground colors
#   for fgc in {30..37}; do
#       # background colors
#       for bgc in {40..47}; do
#           fgc=${fgc#37} # white
#           bgc=${bgc#40} # black

#           vals="${fgc:+$fgc;}${bgc}"
#           vals=${vals%%;}

#           seq0="${vals:+\e[${vals}m}"
#           printf "  %-9s" "${seq0:-(default)}"
#           printf " ${seq0}TEXT\e[m"
#           printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
#       done
#       echo; echo
#   done
# }

# [ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# # Change the window title of X terminals
# case ${TERM} in
#   xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
#       PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
#       ;;
#   screen*)
#       PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
#       ;;
# esac

# use_color=true

# # Set colorful PS1 only on colorful terminals.
# # dircolors --print-database uses its own built-in database
# # instead of using /etc/DIR_COLORS.  Try to use the external file
# # first to take advantage of user additions.  Use internal bash
# # globbing instead of external grep binary.
# safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
# match_lhs=""
# [[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
# [[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
# [[ -z ${match_lhs}    ]] \
#   && type -P dircolors >/dev/null \
#   && match_lhs=$(dircolors --print-database)
# [[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

# if ${use_color} ; then
#   # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
#   if type -P dircolors >/dev/null ; then
#       if [[ -f ~/.dir_colors ]] ; then
#           eval $(dircolors -b ~/.dir_colors)
#       elif [[ -f /etc/DIR_COLORS ]] ; then
#           eval $(dircolors -b /etc/DIR_COLORS)
#       fi
#   fi

#   if [[ ${EUID} == 0 ]] ; then
#       PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
#   else
#       PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
#   fi

#   alias ls='ls --color=auto'
#   alias grep='grep --colour=auto'
#   alias egrep='egrep --colour=auto'
#   alias fgrep='fgrep --colour=auto'
# else
#   if [[ ${EUID} == 0 ]] ; then
#       # show root@ when we don't have colors
#       PS1='\u@\h \W \$ '
#   else
#       PS1='\u@\h \w \$ '
#   fi
# fi

# unset use_color safe_term match_lhs sh
################################################ COLOURS ###################################

# ii:  display useful host related informaton
ii() {
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    #echo -e "\n${RED}Current network location :$NC " ; scselect
    #echo -e "\n${RED}Public facing IP Address :$NC " ;myip
    #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
    echo
}

alias qfind="find . -name "                 # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

# ---------------------------------------------------------------------------------------------------
#                                    Platform dependent setup
# ---------------------------------------------------------------------------------------------------

# Function to check current tools
#     Tries to get version of most common programs,
#     if any of them fails use the POSIX standards.
check_gnu_extesions() {
    if ! ls --version 2>/dev/null 1>&2; then
        echo "posix"
    elif ! cp --version 2>/dev/null 1>&2; then
        echo "posix"
    elif ! touch --version 2>/dev/null 1>&2; then
        echo "posix"
    elif ! ln --version 2>/dev/null 1>&2; then
        echo "posix"
    elif ! mv --version 2>/dev/null 1>&2; then
        echo "posix"
    elif ! rm --version 2>/dev/null 1>&2; then
        echo "posix"
    elif ! cut --version 2>/dev/null 1>&2; then
        echo "posix"
    elif ! find --version 2>/dev/null 1>&2; then
        echo "posix"
    elif ! sort --version 2>/dev/null 1>&2; then
        echo "posix"
    elif ! head --version 2>/dev/null 1>&2; then
        echo "posix"
    elif ! tail --version 2>/dev/null 1>&2; then
        echo "posix"
    elif ! awk --version 2>/dev/null 1>&2; then
        echo "posix"
    elif ! sed --version 2>/dev/null 1>&2; then
        echo "posix"
    else
        echo "gnu"
    fi
}

# Function to check current OS
#     Determine OS on base on the output of uname
#     TODO: Optimize the order
check_os() {
    OSNAME=$(uname)
    if [ "$OSNAME" = "OpenBSD" ]; then
        echo "bsd"
    elif [ "$OSNAME" = "FreeBSD" ]; then
        echo "bsd"
    elif [ "$OSNAME" = "Linux" ]; then
        echo "linux"
    elif [ "$OSNAME" = "Darwin" ]; then
        echo "mac"
    else
        echo "unknown"
    fi
}

# Function to set up a linux environment
set_up_linux() {

    # default flags for makepkg
    export MAKEFLAGS="-j$(nproc)"

    #   Export wechall settings
    export WECHALLUSER="metiu07"
    export WECHALLTOKEN="21960-2CD93-38DA5-76304-F232E-CCE04"
}

# Function to set up a bsd environment
set_up_bsd() {

    echo "test" >/dev/null
    
}

# Set aliases for GNU coreutils
alias_gnu() {

    alias cp='cp -iv'                           # Preferred 'cp' implementation
    alias mv='mv -iv'                           # Preferred 'mv' implementation
    alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
    alias df='df -h'                            # human-readable sizes
    alias ll='ls -FGlAhp --group-directories-first --color=auto' # Preferred 'ls' implementation
    alias ls='ls -G --group-directories-first --color=auto' # Preferred directory listing
    alias less='less -FSRXc'                    # Preferred 'less' implementation
    alias free='free -m'                        # show sizes in MB
    cd() { builtin cd "$@"; ls; }               # Always list directory contents upon 'cd'
    alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
    alias ..='cd ../'                           # Go back 1 directory level
    alias ...='cd ../../'                       # Go back 2 directory levels
    alias .3='cd ../../../'                     # Go back 3 directory levels
    alias .4='cd ../../../../'                  # Go back 4 directory levels
    alias .5='cd ../../../../../'               # Go back 5 directory levels
    alias .6='cd ../../../../../../'            # Go back 6 directory levels
    alias ~="cd ~"                              # ~:            Go Home
    alias c='clear'                             # c:            Clear terminal display
    alias which='type -all'                     # which:        Find executables
    alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
    alias show_options='shopt'                  # Show_options: display bash options settings
    alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
    alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
    alias gdb='gdb -q'                          # gdb:          Make gdb start in quiet mode
    alias em='emacsclient -t'                   # emacs:        Emacs shortcut
    alias gitc='git ls-files | xargs wc -l'     # gitc:         Count all lines in git repository
    alias alert="echo -ne \"\\a\""              # alert:        Print bell character, this is used for tmux monitoring
    alias panpdf='pandoc -V geometry:1in '
    alias vagstart='vagrant up && vagrant ssh'  # vagrant:      Start VM and connect to it via ssh
    alias make='make -j$(nproc)'                # make:         Compile with available threads
    alias makei="make install -j$(nproc); alert" # makei:        Compile install target with available threads
    alias makec='make clean'                    # makec:        Run clean make target
    alias make1='make -j$(nproc --ignore=1)'    # make1:        Compiler with all threads except one, let system keep some resources
    mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
    trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
    ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
    alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop

    #   lr:  Full Recursive Directory Listing
    #   ------------------------------------------
    alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

    #   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
    #           displays paginated result with colored search terms and two lines surrounding each hit.             Example: mans mplayer codec
    #   --------------------------------------------------------------------
    mans () {
        man $1 | grep -iC2 --color=always $2 | less
    }

    #   showa: to remind yourself of an alias (given some part of it)
    #   ------------------------------------------------------------
    showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }

    zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder
    alias numFiles='echo $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir
    alias make1mb='mkfile 1m ./1MB.dat'         # make1mb:      Creates a file of 1mb size (all zeros)
    alias make5mb='mkfile 5m ./5MB.dat'         # make5mb:      Creates a file of 5mb size (all zeros)
    alias make10mb='mkfile 10m ./10MB.dat'      # make10mb:     Creates a file of 10mb size (all zeros)

    #   findPid: find out the pid of a specified process
    #   -----------------------------------------------------
    #       Note that the command name can be specified via a regex
    #       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
    #       Without the 'sudo' it will only find processes of the current user
    #   -----------------------------------------------------
    findPid () { lsof -t -c "$@" ; }

    #   memHogsTop, memHogsPs:  Find memory hogs
    #   -----------------------------------------------------
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

    #   cpuHogs:  Find CPU hogs
    #   -----------------------------------------------------
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

    #   topForever:  Continual 'top' listing (every 10 seconds)
    #   -----------------------------------------------------
    alias topForever='top -l 9999999 -s 10 -o cpu'

    #   ttop:  Recommended 'top' invocation to minimize resources
    #   ------------------------------------------------------------
    #       Taken from this macosxhints article
    #       http://www.macosxhints.com/article.php?story=20060816123853639
    #   ------------------------------------------------------------
    alias ttop="top -R -F -s 10 -o rsize"

    #   my_ps: List processes owned by my user:
    #   ------------------------------------------------------------
    my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }
    
}

# Use POSIX standard
alias_posix() {
    
    alias cp='cp -i'                            # Preferred 'cp' implementation
    alias mv='mv -i'                            # Preferred 'mv' implementation
    alias mkdir='mkdir -p'                      # Preferred 'mkdir' implementation
    alias ll='ls -FlA'                          # Preferred 'ls' implementation
    alias ls='ls -A'                            # Preferred directory listing
    alias less='less -FSRXc'                    # Preferred 'less' implementation
    cd() { builtin cd "$@"; ls; }               # Always list directory contents upon 'cd'
    alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
    alias ..='cd ../'                           # Go back 1 directory level
    alias ...='cd ../../'                       # Go back 2 directory levels
    alias .3='cd ../../../'                     # Go back 3 directory levels
    alias .4='cd ../../../../'                  # Go back 4 directory levels
    alias .5='cd ../../../../../'               # Go back 5 directory levels
    alias .6='cd ../../../../../../'            # Go back 6 directory levels
    alias ~="cd ~"                              # ~:            Go Home
    alias c='clear'                             # c:            Clear terminal display
    alias sl='ls'                               # sl:           To promote my lazines
    alias which='type -all'                     # which:        Find executables
    alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
    alias show_options='shopt'                  # Show_options: display bash options settings
    alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
    alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
    alias gdb='gdb -q'                          # gdb:          Make gdb start in quiet mode
    alias em='emacsclient -t'                   # emacs:        Emacs shortcut
    alias gitc='git ls-files | xargs wc -l'     # gitc:         Count all lines in git repository
    alias panpdf='pandoc -V geometry:1in '      # panpdf:       Convert tex file to pdf with small margins
    mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside

    #   lr:  Full Recursive Directory Listing
    #   ------------------------------------------
    alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

    #   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
    #           displays paginated result with colored search terms and two lines surrounding each hit.             Example: mans mplayer codec
    #   --------------------------------------------------------------------
    mans () {
        man $1 | grep -iC2 --color=always $2 | less
    }

    #   showa: to remind yourself of an alias (given some part of it)
    #   ------------------------------------------------------------
    showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }

    zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder
    alias numFiles='echo $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir
    alias make1mb='mkfile 1m ./1MB.dat'         # make1mb:      Creates a file of 1mb size (all zeros)
    alias make5mb='mkfile 5m ./5MB.dat'         # make5mb:      Creates a file of 5mb size (all zeros)
    alias make10mb='mkfile 10m ./10MB.dat'      # make10mb:     Creates a file of 10mb size (all zeros)

    #   findPid: find out the pid of a specified process
    #   -----------------------------------------------------
    #       Note that the command name can be specified via a regex
    #       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
    #       Without the 'sudo' it will only find processes of the current user
    #   -----------------------------------------------------
    findPid () { lsof -t -c "$@" ; }

    #   memHogsTop, memHogsPs:  Find memory hogs
    #   -----------------------------------------------------
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

    #   cpuHogs:  Find CPU hogs
    #   -----------------------------------------------------
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

    #   topForever:  Continual 'top' listing (every 10 seconds)
    #   -----------------------------------------------------
    alias topForever='top -l 9999999 -s 10 -o cpu'

    #   ttop:  Recommended 'top' invocation to minimize resources
    #   ------------------------------------------------------------
    #       Taken from this macosxhints article
    #       http://www.macosxhints.com/article.php?story=20060816123853639
    #   ------------------------------------------------------------
    alias ttop="top -R -F -s 10 -o rsize"

    #   my_ps: List processes owned by my user:
    #   ------------------------------------------------------------
    my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }
}

CUR_OS=$(check_os)

set_up_"$CUR_OS"

EXT=$(check_gnu_extesions)

alias_"$EXT"

# If file local configuration exists, load it
if [ -f ~/.local_bashrc ]; then
    source ~/.local_bashrc
fi
