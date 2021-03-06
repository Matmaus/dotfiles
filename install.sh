#!/bin/sh
# Author: Matej Kastak
#         Matus Jasnicky
# Start Date: 17.3.2019
#
# Description:
#      This script will copy(symlink) all files to home directory
#      and create backups
#
# Files to install:
# [AUTO] .bashrc                   -> Allways have fresh shell
# [AUTO] .bash_profile             -> Allways have fresh shell
# [AUTO] .tmux.conf                -> Tmux config file
# [AUTO] .vimrc                    -> Vim config file
# [AUTO] .emacs.d/init.el          -> Emacs config file
# [AUTO] .config/i3/config         -> i3 config file
# [AUTO] .config/polybar/config    -> Polybar config file
# [AUTO] .config/polybar/launch.sh -> Polybar launch file
# [AUTO] .Xresources               -> Config file for urxvt(terminal)
# [AUTO] .config/ranger/rc.conf    -> Config file for ranger
#        .radare2rc                -> Radare2 config file
#        .config/i3/config         -> I3 window manager config file
#        .xinitrc                  -> X11 config file
#        .screenrc                 -> Screen config file
#        .zshrc                    -> Zsh config file
#        .tmuxinator/rev.yml       -> Tmuxinator reversing template
#
# [AUTO] My current preference for config files
#
# Plugins to isntall:
#     peda              -> Enhancement for GDB
#     Vundle            -> Plugin manager for vim
#     tmp               -> Plugin manager for tmux

# Set up file variables [AUTO]
BASHRC_CONFIG_FILE=".bashrc"
BASH_PROFILE_CONFIG_FILE=".bash_profile"
TMUX_CONFIG_FILE=".tmux.conf"
VIM_CONFIG_FILE=".vimrc"
EMACS_CONFIG_FILE=".emacs.d/init.el"
RANGER_CONFIG_FILE=".config/ranger/rc.conf"

RADARE2_CONFIG_FILE=".radare2rc"
I3_CONFIG_FILE=".config/i3/config"
POLYBAR_CONFIG_FILE=".config/polybar/config"
POLYBAR_LAUNCH_FILE=".config/polybar/launch.sh"
XINIT_CONFIG_FILE=".xinitrc"
XRESOURCES_CONFIG_FILE=".Xresources"
SCREEN_CONFIG_FILE=".screenrc"
TMUXINATOR_CONFIG_FILE=".tmuxinator/rev.yml"
ZSH_CONFIG_FILE=".zshrc"

# Install variables
INSTALL_PEDA=0
INSTALL_PEDA_REPO="longld/peda"
INSTALL_PEDA_PATH="/home/$USER/.peda"
INSTALL_TMUX_PLUGINS=0
INSTALL_TMUX_PLUGINS_REPO1="tmux-plugins/tpm"
INSTALL_TMUX_PLUGINS_REPO2="tmux-plugins/tmux-sensible"
INSTALL_TMUX_PLUGINS_REPO3="tmux-plugins/tmux-resurrect"
INSTALL_TMUX_PLUGINS_PATH="/home/$USER/.tmux/plugins/tmp"
INSTALL_VIM_PLUGINS=0
INSTALL_VIM_PLUGINS_REPO="VundleVim/Vundle.vim"
INSTALL_VIM_PLUGINS_PATH="home/$USER/.vim/bundle/Vundle.vim"

# INSTALL_COMMAND="mv"
INSTALL_COMMAND="ln -sf"
BACKUP_COMMAND="mv"

DEBUG=0

# Function to print usage of script
print_usage() {
    echo "usage: ./install [-p] [-t] [-v] [-u]"
    echo "    -p: install gdb peda"
    echo "    -t: install tmuxinator"
    echo "    -v: install vim Vundle"
    echo "    -u: print usage"
}

# Function to install config file
#     checks for file if exists, and then copies it
# 
# Arg1: File to be installed
install_config() {
    if [ "$DEBUG" -gt 0 ]; then
	echo "install_config: Installing $1"
    fi

    # We need one argument
    if [ -z "$1" ]; then
	echo "install_config: Wrong number of arguments!">&2
	exit 1
    fi

    # Create home path
    CONFIG_FILE="\$(realpath $1)"
    HOME_FILE=~/"$1"

    # Create backup if necessary, only in case the file is not symlink
    if [ -f "$HOME_FILE" ] && [ ! -L "$HOME_FILE" ]; then
	FINAL_BACKUP="$BACKUP_COMMAND $HOME_FILE $HOME_FILE.bak"
	if [ "$DEBUG" -gt 0 ]; then
	    echo $FINAL_BACKUP
	fi

	eval $FINAL_BACKUP

	if [ "$DEBUG" -gt 0 ]; then
	    echo "Config file '$HOME_FILE' created backup!" >&2
	fi
    else
	if [ "$DEBUG" -gt 0 ]; then
	    echo "Config file '$HOME_FILE' does not exist!" >&2
	fi
    fi

    # Finaly install the config file
    FINAL_COMMAND="$INSTALL_COMMAND $CONFIG_FILE $HOME_FILE"
    eval "$FINAL_COMMAND"
}

# Function to install module(e.g., peda, tmuxinator,...)
#
# Arg1: git repo
# Arg2: install path(home directory)
install_module() {
    if [ "$DEBUG" -gt 0 ]; then
	echo "install_module: Installing $1 in $2"
    fi
    
    if [ -z "$1" ]; then
	echo "install_module: First arguments missing!" >&2
	exit 1
    fi
    
    if [ -z "$2" ]; then
	echo "install_module: Second arguments missing!" >&2
	exit 1
    fi

    # Check if peda is already installed
    if [ ! -d "$2" ]; then
	# Check if git is installed
	# 'command' is more portable
	if command -v git 2>/dev/null; then
	    git clone "https://github.com/$1" "$2"
	    if [ "$INSTALL_PEDA" -eq 1 ]; then
		echo "source ~/.peda/peda.py" >> ~/.gdbinit
	    elif [ "$INSTALL_TMUX_PLUGINS" -eq 1 ]; then
		echo 'Use prefix{`} + I for installing plugins from .tmux.conf'
	    elif [ "$INSTALL_VIM_PLUGINS" -eq 1 ]; then
		vim +PluginInstall +qall
		# use this command to install all plugins from .vimrc
	    fi
		
	else
	    echo "Git is not installed!">&2
	fi
    else
	echo "$2 is already installed."
	echo "Updating..."
	cd "$2" && git pull
    fi
}

# Handle arguments
# TODO: Add install gef options
#       Probably will need to reslove the conflicts between gef and peda
while getopts ":ptvhd" opt; do
    case "$opt" in
	p)
	    INSTALL_PEDA=1
	    ;;
	t)
	    INSTALL_TMUX_PLUGINS=1
	    ;;
	v)
	    INSTALL_VIM_PLUGINS=1
	    ;;
	h)
	    print_usage
	    exit 0
	    ;;
	d)
	    DEBUG=1
	    ;;
	\?)
	    echo "Wrong argument on command line!" >&2
	    print_usage
	    exit 1
	    ;;
    esac
done

# Backup old files
# First check if they exist, if they do then create backup
# And after that install them

# .Xresources
# install_config "$XRESOURCES_CONFIG_FILE"
# .bashrc
install_config "$BASHRC_CONFIG_FILE"
# .bash_profile
install_config "$BASH_PROFILE_CONFIG_FILE"
# .tmux.conf
sudo pacman -Syu --noconfirm tmux
install_config "$TMUX_CONFIG_FILE"
# .vimrc
# install_config "$VIM_CONFIG_FILE"
# .emacs.d/init.el
sudo pacman -Syu --noconfirm emacs
install_config "$EMACS_CONFIG_FILE"
# .config/i3/config
sudo pacman -Syu --noconfirm i3-wm
install_config "$I3_CONFIG_FILE"
# .config/polybar/config
# install_config "$POLYBAR_CONFIG_FILE"
# .config/polybar/launch.sh
# install_config "$POLYBAR_LAUNCH_FILE"
# .config/ranger/rc.conf
sudo pacman -Syu --noconfirm ranger
install_config "$RANGER_CONFIG_FILE"

if [ "$INSTALL_PEDA" -eq 1 ]; then
    install_module "$INSTALL_PEDA_REPO" "$INSTALL_PEDA_PATH"
fi

if [ "$INSTALL_TMUX_PLUGINS" -eq 1 ]; then
    install_module "$INSTALL_TMUX_PLUGINS_REPO1" "$INSTALL_TMUX_PLUGINS_PATH"
    install_module "$INSTALL_TMUX_PLUGINS_REPO2" "$INSTALL_TMUX_PLUGINS_PATH"
    install_module "$INSTALL_TMUX_PLUGINS_REPO3" "$INSTALL_TMUX_PLUGINS_PATH"
fi

if [ "$INSTALL_VIM_PLUGINS" -eq 1 ]; then
    install_module "$INSTALL_VIM_PLUGINS_REPO" "$INSTALL_VIM_PLUGINS_PATH"
fi
