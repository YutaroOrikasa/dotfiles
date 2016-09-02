#public domain

#see man zshall for detail

### setops ###
# see man zshoptions
setopt AUTO_CD
setopt AUTO_PUSHD  # cd -[tab] OR cd +[tab] with comp module
setopt PUSHD_MINUS  # reverse order cd -[tab]
setopt PUSHD_SILENT  # you can use "pushd" "popd" command comftably
setopt WARN_CREATE_GLOBAL  # in function
setopt SHARE_HISTORY
setopt INTERACTIVE_COMMENTS
setopt HIST_IGNORE_DUPS  # ignore duplicate of previous command on hisory.
setopt CORRECT  # spelling correction

#dircolors

### PARAMETERS USED BY THE SHELL ###
REPORTTIME=1
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
alias zsh-glob-help='man -P "less +/\"   Glob Qualifiers\""  zshexpn'

autoload -U add-zsh-hook


function zshaddhistory(){
    
        local cmdline="${1%$'\n'}"
        local cmd="${cmdline%% *}"
        [[ ${cmd} != 'nohist' ]] 
}

### zle(key bindings) ### 
function suspend-or-fg() {
    if [ -n "$jobstates" ]; then
	zle push-input
	BUFFER="nohist fg"
	zle accept-line
	#simplely execute "nohist fg" does not work well :(
    fi
}
zle -N suspend-or-fg
bindkey -M emacs '^z' suspend-or-fg

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

function backward-kill-word-or-kill-region {
    if [ x$LASTWIDGET = x"backward-kill-word-or-kill-region" ];then
        local CUTBUF_BACKUP=$CUTBUFFER
    fi
    
    if [ $REGION_ACTIVE = 1 ];then
        zle kill-region
    else
        zle backward-kill-word
    fi

    CUTBUFFER="$CUTBUFFER""$CUTBUF_BACKUP"
}
zle -N backward-kill-word-or-kill-region
bindkey '^W' backward-kill-word-or-kill-region

### prompt ###
setopt prompt_subst
autoload -U colors
colors

# old prompt
# PROMPT="%{$fg_bold[red]%}%(?..%? )%{${reset_color}%}%{$fg_bold[cyan]%}%n%{${reset_color}%}@%{$fg_no_bold[yellow]%}%m%{${reset_color}%} %B%40<..<%~%<< %b"'${vcs_info_msg_0_}'"% %# "

USER_HASH=$(printf %s $USER | md5sum)
HOST_HASH=$(printf %s $HOST | md5sum)

USER_HASH=${USER_HASH_DEBUG:-"$USER_HASH"}
HOST_HASH=${HOST_HASH_DEBUG:-"$HOST_HASH"}


USER_COL_NUM=$(( 0x$(echo $USER_HASH | dd bs=1 count=2 2>/dev/null)))
HOST_COL_NUM=$(( 0x$(echo $HOST_HASH | dd bs=1 count=2 2>/dev/null)))

PROMPT_USERNAME=$(echo -e "%{\e[38;5;${USER_COL_NUM}m%}%n%{\e[0m%}")
PROMPT_HOSTNAME=$(echo -e "%{\e[38;5;${HOST_COL_NUM}m%}%m%{\e[0m%}")

PROMPT_EXEC_STATUS="%(?.%{$fg[yellow]%}:) .%{$fg_bold[red]%}%? )%{${reset_color}%}"
PROMPT="$PROMPT_EXEC_STATUS""$PROMPT_USERNAME"@"$PROMPT_HOSTNAME"" %~""%50(l."$'\n'".)"'${vcs_info_msg_0_}'" %# "

# make new line after path when path is too long
# make new line after path when vcs info appears
# avoid double new line
# see also vcs info section


### completion ###
zstyle ':completion:*:default' menu select=2  # highlight and select with arrow key
bindkey "^[[Z" reverse-menu-complete # reverse at [shift + tab]

### vcs info ###
# see http://qiita.com/mollifier/items/8d5a627d773758dd8078
# or
# man zshcontrib
autoload -Uz vcs_info
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!%f"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+%f"
zstyle ':vcs_info:*' formats "%%1(l."$'\n'".)""%c%u%F{magenta}(%f%s%F{magenta})%F{yellow}-%F{magenta}[%B%F{blue}%b%%b%F{magenta}]%f%}"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

##### bash compatible ####
alias ls='ls --color=auto'
alias grep='grep --color=auto'
export LESS='-r -gj10'

alias g='git'
alias gcho='git checkout'
alias gchob='git checkout -b'
alias gl='git log --oneline --decorate --graph --branches --tags --remotes '

alias lsa='ls -a'
alias lsl='ls -l'
alias lsdl='ls -dl'

alias open=cygstart
export CYGWIN="winsymlinks"

function nohist(){
        "$@"
}

export EDITOR=emacs

# avoid ^S terminal locking issue
stty stop undef

### experimental ###
fpath=(${HOME}/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit

#. ~/.otokono_zsh
#. ~/.zsh_grml_comp

function set_term_title () {
    case "${TERM}" in
	xterm*|kterm*)
	    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
	    ;;
	screen*)
	    echo -ne "\033P\033]0;${USER}@${HOST%%.*}:${PWD}\007\033\\"
	    ;;
    esac
    
}

add-zsh-hook precmd set_term_title
add-zsh-hook chpwd set_term_title


alias L='less'

function mkcdir {
    mkdir "$@" && cd $_
}
alias mkcd=mkcdir

export PATH=/mybin:"$PATH"

[ -e ~/.zshrc.mine ] && . ~/.zshrc.mine || true
# exit status will always be success.
