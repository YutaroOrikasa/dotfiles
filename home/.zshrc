#public domain

[ -e ~/.zshrc.mine-pre ] && . ~/.zshrc.mine-pre

export ALLOW_OVER_ENGINEERING=${ALLOW_OVER_ENGINEERING:-y}


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
setopt hist_ignore_space  # Do not record history when command line starts with a space

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
        [[ ${cmd} != 'nohist' ||
         "$cmdline" =~ '(g|git) push (-f|--force)' ]] 
}

### zle(key bindings) ###

# enable tab key complete with no space after cursor
# https://stackoverflow.com/questions/13341900/zsh-how-do-i-set-autocomplete-so-that-it-inserts-the-completion-when-cursor-is
bindkey '^i' expand-or-complete-prefix

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

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[3~" delete-char

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

case "$(uname)" in
    Darwin)
        __md5=md5
        ;;
    *)
        __md5=md5sum
        ;;
esac

function __col256echo {
    if [ -n "$2" ];then
        echo -e "\e[38;5;$2m$1\e[0m"
    else
        echo "$1"
    fi
}


function __ask-prompt-color {
    (
        set -o NO_WARN_CREATE_GLOBAL
        subject="$1"
        name="$2"
        while :;do
            echo "select a color of $subject of prompt" >&2
            echo "0-255: 256 color, l: list sample, s: skip, n: no color, a: auto" >&2
            read -r input
            if [[ "$input" =~ '^[0-9]+$' ]] && (( 0<=input && input <= 255 ));then
                COL_NUM=$input
            else
                case "$input" in
                    l)
                        for i in $(seq 0 255);do
                            __col256echo "$name $i" $i >&2
                        done
                        continue
                        ;;
                    s)
                        return
                        ;;
                    a)
                        HASH=$(printf %s $name | $__md5)
                        # using first 2 chars for 256 color number
                        COL_NUM=$(( 0x$(echo $HASH | dd bs=1 count=2 2>/dev/null)))
                        
                        ;;
                    n)
                        COL_NUM=no
                        ;;
                    *)
                        echo "bad input $input" >&2
                        continue
                        ;;
                esac
            fi
            __col256echo "$name $COL_NUM" $COL_NUM >&2
            echo "OK? [y/n]" >&2
            read -r input
            if [ "$input" = y ];then
                echo $COL_NUM
                return
            fi
        done
    )
}

if [ -z "$USER_COL_NUM" ];then
    USER_COL_NUM=$(__ask-prompt-color "user name" "$USER")
    if [ -n "$USER_COL_NUM" ];then
        echo "save $subject color $USER_COL_NUM to .zshrc.mine-pre"
        echo >> ~/.zshrc.mine-pre
        echo USER_COL_NUM=$USER_COL_NUM >> ~/.zshrc.mine-pre
    else
        echo "skip setting user name color"
    fi
fi


if [ -z "$HOST_COL_NUM" ];then
    HOST_COL_NUM=$(__ask-prompt-color "host name" "$HOST")
    if [ -n "$HOST_COL_NUM" ];then
        echo "save $subject color $HOST_COL_NUM to .zshrc.mine-pre"
        echo >> ~/.zshrc.mine-pre
        echo HOST_COL_NUM=$HOST_COL_NUM >> ~/.zshrc.mine-pre
    else
        echo "skip setting host name color"
    fi
fi

function __USER_COL_ESC_SEQ {
    if [ -n "$USER_COL_NUM" -a "$USER_COL_NUM" != "no" ];then
        echo "%{\e[38;5;${USER_COL_NUM}m%}"
    fi
}

function __HOST_COL_ESC_SEQ {
    if [ -n "$HOST_COL_NUM" -a "$HOST_COL_NUM" != "no" ];then
        echo "%{\e[38;5;${HOST_COL_NUM}m%}"
    fi
}

PROMPT_USERNAME=$(echo -e '$(__USER_COL_ESC_SEQ)%n%{\e[0m%}')
PROMPT_HOSTNAME=$(echo -e '$(__HOST_COL_ESC_SEQ)%m%{\e[0m%}')


PROMPT_EXEC_STATUS="%(?.%{$fg[yellow]%}:) .%{$fg_bold[red]%}%? )%{${reset_color}%}"

function __prompt_untracked_files {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1;then
        return
    fi
    
    if [[ -n "$(git ls-files --others --exclude-standard)" ]] ;then
        echo "%1(l."$'\n'".)"'%B%F{red}*%b%f'
        
    else
        echo ''
    fi
}

PROMPT="$PROMPT_EXEC_STATUS""$PROMPT_USERNAME"@"$PROMPT_HOSTNAME"" %~""%50(l."$'\n'".)"'${vcs_info_msg_0_}'"%20(l."$'\n'".)"'$(__prompt_untracked_files)'" %# "

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
zstyle ':vcs_info:*' actionformats "%%1(l."$'\n'".)""%%b%f%c%u%F{magenta}(%f%s%F{magenta})%F{yellow}-%F{magenta}[%B%F{blue}%b%%b%F{magenta}]%f%}"$'\n'"%B%F{red}%a>>>%%b%f"

# Sometimes zsh vcs plugin make trouble.
# So these are convinient functions for toggle zsh vcs plugin.
vcs-disable () {
    add-zsh-hook -d precmd vcs_info
    vcs_info_msg_0_=
}
vcs-enable () {
    add-zsh-hook precmd vcs_info
}
alias disable-vcs=vcs-disable
alias enable-vcs=vcs-enable
#### misc ####

alias pd=popd


export MEMOFILE=~"/memo.txt"

function memo {
    if [ x"$1" = x"-e" -o $# = 0 ];then
        emacs "$MEMOFILE"
        return
    fi
    echo "$@" >> "$MEMOFILE"
    echo  >> "$MEMOFILE"
}

function my-accept-line {
    if [[ -n "$BUFFER" ]];then
        zle accept-line
    else
        if git rev-parse --is-inside-work-tree &> /dev/null;then
            git status
        fi
        # for poping line pushed by alt-q (zle push-line)
        zle accept-line
    fi
    
}

zle -N my-accept-line
bindkey '^M' my-accept-line


# workaround for emacs tramp
if [[ "$TERM" == "dumb" ]]
then
  unsetopt zle
  unsetopt prompt_cr
  unsetopt prompt_subst
  unfunction precmd
  unfunction preexec
  PS1='$ '
fi

alias ls='ls --color=auto'


alias grep='grep --color=auto'
export LESS='-r -gj10'

alias g='git'
alias gc='git commit -v'
alias gcho='git checkout'
alias gchob='git checkout -b'
alias gchop='git checkout -'  # go to previous branch
alias greset='git reset'
alias gl='git log --decorate --graph --branches --tags --remotes'
alias glh='git log --decorate --graph HEAD'
alias gd='git diff'
alias lsa='ls -a'
alias lsl='ls -l'
alias lsdl='ls -dl'
alias ssh='ssh -A'

# raw vim
alias rawvim='vim -u NONE -N'

alias sshfs='sshfs -o transform_symlinks -o ServerAliveCountMax=1 -o ServerAliveInterval=1 -o reconnect'

case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
    cygwin*)
        alias open=cygstart
        export CYGWIN="winsymlinks"
        ;;
esac

alias o='open .'

if [ x"$TERM" = x"screen.xterm-256color" ];then
    export TERM=xterm-256color
fi

function nohist(){
        "$@"
}

# automatic undoable mv command
# ommiting option handling for simpleness for implementation
function mv() {
    if [ "$#" = 2 -a ! -e "$1" -a -e "$2" ];then
        echo undo mv "$1" "$2" >&2
        command mv "$2" "$1"
    else
        command mv "$@"
    fi
}

export EDITOR='emacs'

alias nwemacs='command emacs -nw'

function custom-emacs {
    # usage: custom-emacs custom-emacs.d [args]...
    local custom="$1"
    shift
    emacs -q -l "$custom"/init.el --eval"=(when load-file-name (setq user-emacs-directory (file-name-directory load-file-name)))" "$@"
}

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

function notify_pwd_to_emacs_ansi_term () {
    print -P "\033AnSiTc %d"
}

if [ -n "$INSIDE_EMACS" ]; then
    add-zsh-hook chpwd notify_pwd_to_emacs_ansi_term
    print -P "\033AnSiTu %n"
    print -P "\033AnSiTc %d"
fi

alias L='less'

function mkcdir {
    mkdir "$@" && cd $_
}
alias mkcd=mkcdir


function e {

    wemacsclient -a "" "$@"
}

# homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions/ $fpath)

export PATH=/mybin:~/.usr/bin:~/.local/bin:"$PATH"

# execute hacks for each platform
__uname=$(uname)
[ -e ~/.dotfiles-lib/hack/"$__uname".sh ] && . ~/.dotfiles-lib/hack/"$__uname".sh


[ -e ~/.zshrc.mine ] && . ~/.zshrc.mine
[ -e ~/.zshrc.mine.zsh ] && . ~/.zshrc.mine.zsh


autoload -U compinit

if [ "$ALLOW_OVER_ENGINEERING" = y ];then
    source ~/.over-engineering/.zshrc
fi

compinit
