#!/bin/zsh

platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
    platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    platform='darwin'
fi
hostname=$(cat /etc/hostname)

# Lines configured by zsh-newuser-install
HISTSIZE=100000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=100000               #Number of history entries to save to disk
#HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killedbindkey -v
setopt INC_APPEND_HISTORY

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ruin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
autoload -U promptinit
promptinit
autoload -U colors && colors

source /etc/profile

# PROMPT="[%{$fg[red]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}][%{$fg_no_bold[blue]%}%~%{$reset_color%}]"
# RPS1="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"
PROMPT=' %B%F{red}» %f%b'
RPROMPT='%B%F{blue}%~ %B%F{white}%#%b'
# PROMPT="%{$fg[blue]%}%~%{$reset_color%} %{$fg[black]%}>> %{$reset_color%}"

export EDITOR="vim"
export ALTERNATE_EDITOR=""
source $HOME/.aliases
source $HOME/.zshrc.functions
# source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/share/zsh/plugins/zsh-syntax-highlighting/highlighters
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan,underline"
source $HOME/.zsh/git.zsh

if [[ $platform == 'darwin' ]]; then
    export HOMEBREW_NO_ANALYTICS=1
fi

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
#bindkey "$terminfo[kcuu1]" history-substring-search-up
#bindkey "$terminfo[kcud1]" history-substring-search-down

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

if [[ $platform == 'linux' ]]; then
    eval $( dircolors -b $HOME/LS_COLORS )
elif [[ $platform == 'darwin' ]]; then
    eval $( gdircolors -b $HOME/LS_COLORS )
fi
export LS_COLORS

# set number of make threads to number of processors
threads=1
if [[ $platform == 'linux' ]]; then
    threads=$(grep -c ^processor /proc/cpuinfo)
elif [[ $platform == 'darwin' ]]; then
    threads=$(sysctl -n hw.ncpu)
fi
export MAKEFLAGS="-j $threads"

if [[ $platform == 'darwin' ]]; then
    # GDK_PIXBUF_MODULEDIR=$HOMEBREW/lib/gdk-pixbuf-2.0/2.10.0/loaders gdk-pixbuf-query-loaders --update-cache
fi

zstyle ':completion:*' rehash true

if [[ $platform == 'darwin' ]]; then
    export PATH=/usr/local/bin:$PATH
    export PATH=$PATH:$HOME/.local/bin
    export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH
    launchctl setenv PATH $PATH
fi

if [ -e "/usr/local/share/chruby/chruby.sh" ]; then
    source /usr/local/opt/chruby/share/chruby/chruby.sh
    source /usr/local/opt/chruby/share/chruby/auto.sh
    chruby ruby-2.4.1
fi

export PATH=$PATH:$HOME/.bin
export PATH=$PATH:$HOME/.gem/ruby/2.6.0/bin
export PATH=$PATH:$HOME/.luarocks/bin
export PATH=$PATH:$HOME/.cargo/bin
export RUST_SRC_PATH=/mnt/hibiki/build/rust/src
export RUST_BACKTRACE=1

export PATH=$PATH:/sbin:/usr/sbin

eval $(luarocks path)

#export LC_ALL=ja_JP.UTF-8

setopt AUTO_MENU           # Show completion menu on a succesive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt LIST_AMBIGUOUS
unsetopt NOMATCH
setopt HIST_IGNORE_SPACE
setopt RM_STAR_WAIT

setopt AUTO_PUSHD                  # pushes the old directory onto the stack
setopt PUSHD_MINUS                 # exchange the meanings of '+' and '-'
setopt CDABLE_VARS                 # expand the expression (allows 'cd -2/tmp')
autoload -U compinit && compinit   # load + start completion
zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'

export STOW_DIR="/usr/local/stow"
export GOPATH=~/build/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH=/usr/lib/go/bin/:$PATH

export PATH=$PATH:$HOME/miniconda3/bin
export PATH=$PATH:/home/ruin/.gem/ruby/2.5.0/bin
export PATH=$PATH:/home/hiro/build/elona-next
export ERL_AFLAGS="-kernel shell_history enabled"
export BOOST_ROOT=~/build/boost_1_66_0
export BROWSER=elinks
export NODE_ENV=development
export GTAGSCONF=/usr/share/gtags/gtags.conf
export GTAGSLABEL=pygments
export MANPATH=$MANPATH:/usr/local/share/man
export COLORTERM=24bit

(cd ~/.dotfiles && exec dot-check)

if [ -f ~/.cargo/env ]; then
   source ~/.cargo/env
fi

# Simpler prompt when using Emacs
if [ "$TERM" = "eterm-color" ]; then
    PS1="%~ %# "
    RPS1=
fi

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

pgrep -u hiro emacs > /dev/null || emacs --daemon > /dev/null 2>&1 &
