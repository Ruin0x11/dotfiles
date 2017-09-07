platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
    platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    platform='darwin'
fi
hostname=$(hostname)

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ruin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
autoload -U promptinit
promptinit
autoload -U colors && colors

# PROMPT="[%{$fg[red]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}][%{$fg_no_bold[blue]%}%~%{$reset_color%}]"
# RPS1="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"
PROMPT=' %B%F{red}» %f%b'
RPROMPT='%B%F{blue}%~ %B%F{white}%#%b'
# PROMPT="%{$fg[blue]%}%~%{$reset_color%} %{$fg[black]%}>> %{$reset_color%}"

export EDITOR="vim"
export ALTERNATE_EDITOR=""
source $HOME/.aliases
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
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
    GDK_PIXBUF_MODULEDIR=$HOMEBREW/lib/gdk-pixbuf-2.0/2.10.0/loaders gdk-pixbuf-query-loaders --update-cache
fi

zstyle ':completion:*' rehash true

if [[ $platform == 'darwin' ]]; then
    export PATH=/usr/local/bin:$PATH
    export PATH=$PATH:$HOME/.local/bin
    export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH
    launchctl setenv PATH $PATH
fi

if [ -e "/usr/local/share/chruby/chruby.sh" ]; then
    source /usr/local/share/chruby/chruby.sh 
    chruby ruby-2.3.3
fi

export PATH=$PATH:$HOME/.bin
export PATH=$PATH:$HOME/.gem/ruby/2.3.0/bin

export LC_ALL=ja_JP.UTF-8

setopt AUTO_MENU           # Show completion menu on a succesive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt LIST_AMBIGUOUS
setopt HIST_IGNORE_SPACE

export GOPATH=~/build/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH=/usr/lib/go/bin/:$PATH

export PATH=$PATH:$HOME/miniconda3/bin

if [[ $hostname == 'memento' ]]; then
    export PANEL_FIFO="/tmp/panel-fifo"
    wmname LG3D

    export GPG_TTY=$(tty)
    echo | en gpg -s > /dev/null

    envoy -t ssh-agent
    source <(envoy -p)
fi

(cd ~/.dotfiles && exec dot-check)

PATH="/Users/ruin/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/ruin/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/ruin/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/ruin/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/ruin/perl5"; export PERL_MM_OPT;
export PATH="/usr/local/sbin:$PATH"

source $HOME/.cargo/env
export CARGO_INCREMENTAL=1
source $HOME/.zshrc.functions

export PATH=$PATH:/Library/TeX/Distributions/.DefaultTeX/Contents/Programs/texbin

export DB_USER=`whoami`
export DB_NAME=`whoami`
