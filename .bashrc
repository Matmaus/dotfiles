#!/bin/bash
# Author: Matej Kastak
# Start date: 2.4.2017
# Modification of great bash config from:
# https://natelandau.com/my-mac-osx-bash_profile/
# ---------------------------------------------------------------------------
# Description:  This file holds all my BASH configurations and aliases
#
# Set the shell prompt
# export PS1="\[\e[01;31m\]\u\[\e[0m\]\[\e[00;37m\]@\h:\[\e[0m\]\[\e[00;36m\][\W]\[\e[0m\]\[\e[00;37m\]\\$ \[\e[0m\]"
export PS1="\[\e[32m\]\u\[\e[m\]@\h:\[\e[31m\][\[\e[m\]\W\[\e[31m\]]\[\e[m\]\\$ "

# Set Paths
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11R6/bin:/usr/local/bin"

# Set Default Editor
# If emacs is installed use that option otherwise select vim as default editor
if command -v emacsclient >/dev/null 2>&1; then
    export EDITOR="emacsclient -t"
else
    export EDITOR=/usr/bin/vim
fi

# Set default blocksize for ls, df, du
export BLOCKSIZE=1k

# export CLICOLOR=1
# export LSCOLORS=ExFxBxDxCxegedabagacad

# bind TAB:menu-complete
complete -cf sudo
complete -cf man

# extract:  Extract most know archives with one command
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

# Function to set up a mac environment
set_up_mac() {

    export PATH="/opt/local/libexec/gnubin:$PATH:/usr/local/bin/"
    export PATH="$HOME/.gem/ruby/2.3.0/bin:/usr/local/git/bin:/sw/bin/:/usr/local/bin:/usr/local/:/usr/local/sbin:/usr/local/mysql/bin:$PATH"

    # cdf:  'Cd's to frontmost window of MacOS Finder
    cdf () {
	currFolderPath=$( /usr/bin/osascript <<EOT
	    tell application "Finder"
		try
	    set currFolder to (folder of the front window as alias)
		on error
	    set currFolder to (path to desktop folder as alias)
		end try
		POSIX path of currFolder
	    end tell
EOT
		      )
	echo "cd to \"$currFolderPath\""
	cd "$currFolderPath"
    }

    # vag: Start and ssh into vagrant machine
    vag () {
	if [ -f ~/vagrant/$1/Vagrantfile ] ; then
	    cd ~/vagrant/$1 && vagrant up && vagrant ssh
	else
	    echo "'$1' is not valid vagrant machine."
	fi
    }

    alias edit='subl'                           # edit:         Opens any file in sublime editor
    alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
    alias youdown='youtube-dl --extract-audio --audio-format mp3 ' # youdown: Download youtube video
    alias vagstart='vagrant up && vagrant ssh'  # vagarnat:     Start VM and connect to it via ssh
    trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
    ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
    alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop

    # spotlight: Search for a file using MacOS Spotlight's metadata
    spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }

    alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
    alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
    alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
    alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
    alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
    alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
    alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
    alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
    alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
    alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

    alias mountReadWrite='/sbin/mount -uw /'    # mountReadWrite:   For use when booted into single-user

    # cleanupDS:  Recursively delete .DS_Store files
    alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

    # finderShowHidden:   Show hidden files in Finder
    # finderHideHidden:   Hide hidden files in Finder
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

    # cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
    alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

    # screensaverDesktop: Run a screensaver on the Desktop
    alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

    # Web development
    alias apacheEdit='sudo edit /etc/httpd/httpd.conf'      # apacheEdit:       Edit httpd.conf
    alias apacheRestart='sudo apachectl graceful'           # apacheRestart:    Restart Apache
    alias editHosts='sudo edit /etc/hosts'                  # editHosts:        Edit /etc/hosts file
    alias herr='tail /var/log/httpd/error_log'              # herr:             Tails HTTP error logs
    alias apacheLogs="less +F /var/log/apache2/error_log"   # Apachelogs:   Shows apache error logs
    httpHeaders () { /usr/bin/curl -I -L $@ ; }             # httpHeaders:      Grabs headers from web page

    # httpDebug:  Download a web page and show info on what took time
    httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }

    #   Original reminders from the scipt
    #
    #   remove_disk: spin down unneeded disk
    #   ---------------------------------------
    #   diskutil eject /dev/disk1s3

    #   to change the password on an encrypted disk image:
    #   ---------------------------------------
    #   hdiutil chpass /path/to/the/diskimage

    #   to mount a read-only disk image as read-write:
    #   ---------------------------------------
    #   hdiutil attach example.dmg -shadow /tmp/example.shadow -noverify

    #   mounting a removable drive (of type msdos or hfs)
    #   ---------------------------------------
    #   mkdir /Volumes/Foo
    #   ls /dev/disk*   to find out the device to use in the mount command)
    #   mount -t msdos /dev/disk1s1 /Volumes/Foo
    #   mount -t hfs /dev/disk1s1 /Volumes/Foo

    #   to create a file of a given size: /usr/sbin/mkfile or /usr/bin/hdiutil
    #   ---------------------------------------
    #   e.g.: mkfile 10m 10MB.dat
    #   e.g.: hdiutil create -size 10m 10MB.dmg
    #   the above create files that are almost all zeros - if random bytes are desired
    #   then use: ~/Dev/Perl/randBytes 1048576 > 10MB.dat

    ##
    # Your previous /Users/mato/.bash_profile file was backed up as /Users/mato/.bash_profile.macports-saved_2015-08-17_at_18:50:41
    ##

    # MacPorts Installer addition on 2015-08-17_at_18:50:41: adding an appropriate PATH variable for use with MacPorts.
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
    # Finished adapting your PATH environment variable for use with MacPorts.

    ##
    # Your previous /Users/mato/.bash_profile file was backed up as /Users/mato/.bash_profile.macports-saved_2015-11-07_at_20:53:26
    ##

    # MacPorts Installer addition on 2015-11-07_at_20:53:26: adding an appropriate PATH variable for use with MacPorts.
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
    # Finished adapting your PATH environment variable for use with MacPorts.

    ##
    # Your previous /Users/mato/.bash_profile file was backed up as /Users/mato/.bash_profile.macports-saved_2015-11-07_at_21:35:24
    ##

    # MacPorts Installer addition on 2015-11-07_at_21:35:24: adding an appropriate PATH variable for use with MacPorts.
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
    # Finished adapting your PATH environment variable for use with MacPorts.

}

# Function to set up a linux environment
set_up_linux() {

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
    alias ll='ls -FGlAhp --group-directories-first --color=auto' # Preferred 'ls' implementation
    alias ls='ls -G --group-directories-first --color=auto' # Preferred directory listing
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
    alias which='type -all'                     # which:        Find executables
    alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
    alias show_options='shopt'                  # Show_options: display bash options settings
    alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
    alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
    alias gdb='gdb -q'                          # gdb:          Make gdb start in quiet mode
    alias em='emacsclient -t'                   # emacs:        Emacs shortcut
    alias gitc='git ls-files | xargs wc -l'     # gitc:         Count all lines in git repository
    alias panpdf='pandoc -V geometry:1in '
    alias vagstart='vagrant up && vagrant ssh'  # vagrant:      Start VM and connect to it via ssh
    alias make='make -j4'                       # make:         Compile with 4 threads
    alias makei='make install -j4'              # makei:        Compile install target with 4 threads
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
