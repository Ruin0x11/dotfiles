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

export EDITOR=""
export ALTERNATE_EDITOR=""
source $HOME/.aliases
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source $HOME/.zsh/git.zsh

export LOCU_API_KEY="880b6cc12082c5a803b0f0bb6d334639db8f996e"

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# eval $( dircolors -b $HOME/LS_COLORS )
#eval $( keychain -q --eval --agents ssh id_rsa ) 

export LS_COLORS
export MAKEFLAGS='-j 4'
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH

#[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

zstyle ':completion:*' rehash true

# source /usr/share/chruby/chruby.sh
# chruby ruby-2.3.0
# PATH=$PATH:/home/ruin/.gem/ruby/2.2.0/bin
PATH=$PATH:/home/ruin/.gem/ruby/2.3.0/bin

PATH=$PATH:/Users/ipickering/.bin
export PATH=/usr/local/bin:$PATH

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

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export PANEL_FIFO="/tmp/panel-fifo"

# wmname LG3D

# export GPG_TTY=$(tty)

# gpg-preset-passphrase fails, so do an ugly hack instead
# echo | en gpg -s > /dev/null

# if [[ "$SSH_AGENT_PID" == "" ]]; then
#     eval $(keychain --eval --agents ssh -Q --quiet id_rsa)
# fi

# envoy -t ssh-agent
# source <(envoy -p)

PATH="/home/ruin/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/ruin/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/ruin/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/ruin/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/ruin/perl5"; export PERL_MM_OPT;
