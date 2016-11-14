#!/bin/sh

# The user profile and bashrc contain circular references to one another
# because different forms of accessing the system lead to different loading
# behaviors (an "*" indicates only part of the file is executed):
#
#   ssh $LOGNAME@$HOSTNAME:              ~/.profile -> ~/.bashrc
#   ssh $LOGNAME@$HOSTNAME "command...": ~/.bashrc* -> ~/.profile
#   X11 Session:                         ~/.profile
#   └─> GUI Terminal Emulator:           ~/.bashrc
#
# Since the profile modifies the PATH environment variable, it is always
# loaded, but the entirety of the bashrc is only loaded when Bash is running as
# an interactive shell.
test "$PROFILE_INCLUDE_GUARD" && return || export PROFILE_INCLUDE_GUARD="$$"

umask 077

export BC_ENV_ARGS="-l -q"
export BROWSER="google-chrome:firefox:chromium"
export BZIP2="-9"
export EDITOR="vi"
export EXINIT="set verbose smd ic ai sw=4 ts=4 | map gg 1G"
export GZIP="-9"
export LESS="iMR"
export LZOP="-9"
export MANSECT="3:3posix:2:1:l:7:8:5:4:9:6:3am:n:3pm:3perl"
export PAGER="less"
export PS_FORMAT="user,pid,ppid,stime,comm,cmd"
export PYTHONSTARTUP="$HOME/.pyrepl.py"
export TERMINFO="$HOME/.terminfo"
export USER="$LOGNAME"
export WINEDLLOVERRIDES="winemenubuilder.exe=d"
export WINEPREFIX="/dev/null"
export XDG_CACHE_HOME="/tmp/xdg-cache-$LOGNAME"
export XZ_OPT="-9"
export _JAVA_AWT_WM_NONREPARENTING="1"

export VISUAL="$EDITOR"

sysconfigs="$(dirname "$(readlink "$HOME/.profile")")"
PATH="$HOME/bin:$sysconfigs/scripts:$HOME/.local/bin:$PATH"
unset sysconfigs

# Secondary profile for machine-specific settings.
. "$HOME/.local.profile" 2>/dev/null

# Most variables and settings that depend on other programs are processed after
# the local profile since it may modify PATH.
export GIT_EDITOR="$(which "$EDITOR")"
export MAKEFLAGS="-j$(nproc 2>/dev/null || echo 4)"
export MANPATH="$(manpath 2>/dev/null)"
export SHELL="$(which bash)"

eval "$(dircolors -b "$HOME/.dir_colors")"
eval "$(lesspipe)"

# Load ~/.bashrc for interactive Bash sessions.
test -z "$BASH_VERSION" -o -z "$PS1" || . "$HOME/.bashrc"