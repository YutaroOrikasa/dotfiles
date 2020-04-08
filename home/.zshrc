#public domain

# export DOTFILES_ENABLE_ZPROF=y for zshrc profiling
if [ "$DOTFILES_ENABLE_ZPROF" = y ];then
    zmodload zsh/zprof
fi

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
setopt GLOB_DOTS  # `*` will match dot files (eg. * => .zshrc .emacs.d ...etc).

#dircolors

### PARAMETERS USED BY THE SHELL ###
REPORTTIME=1
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
alias zsh-glob-help='man -P "less +/\"   Glob Qualifiers\""  zshexpn'

autoload -U add-zsh-hook

# WORDCHARS is chars ingored from word separator.
# It affects M-b and ^w, etc.
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>"'

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

    # `zle backward-kill-word' will appropriately set $CUTBUFFER
    # with this.
    zle -f kill
    
    if [ $REGION_ACTIVE = 1 ];then
        zle kill-region
    else
        zle backward-kill-word
    fi

}
zle -N backward-kill-word-or-kill-region
bindkey '^W' backward-kill-word-or-kill-region

function backward-kill-word-with-default-separator {
    zle -f kill

    local WORDCHARS_BAK=$WORDCHARS
    unset WORDCHARS

    zle backward-kill-word

    WORDCHARS=$WORDCHARS_BAK
}

zle -N backward-kill-word-with-default-separator

bindkey '^X^W' backward-kill-word-with-default-separator
bindkey '^[w' backward-kill-word-with-default-separator

### prompt ###
setopt prompt_subst
autoload -U colors
colors

source ~/.over-engineering/zshrc-color-prompt.zsh

PROMPT_EXEC_STATUS="%(?.%{$fg[yellow]%}:) .%{$fg_bold[red]%}%? )%{${reset_color}%}"

__enable_prompt_untracked_files=y

function __prompt_untracked_files {
    if [ "$__enable_prompt_untracked_files" != y ];then
        return
    fi

    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1;then
        return
    fi
    
    if [[ -n "$(git ls-files --others --exclude-standard)" ]] ;then
        echo "%1(l."$'\n'".)"'%B%F{red}*%b%f'
        
    else
        echo ''
    fi
}

# make new line after path when path is too long
# make new line after path when vcs info appears
# avoid double new line
# see also vcs info section
PROMPT="$PROMPT_EXEC_STATUS""$PROMPT_USERNAME"@"$PROMPT_HOSTNAME"" %~""%50(l."$'\n'".)"'${vcs_info_msg_0_}'"%20(l."$'\n'".)"'$(__prompt_untracked_files)'" %# "


### completion ###

# highlight and select with arrow key
zstyle ':completion:*:default' menu select=2

# reverse at [shift + tab]
bindkey "^[[Z" reverse-menu-complete

# grouping candidates
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''


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
    __enable_prompt_untracked_files=n
    add-zsh-hook -d precmd vcs_info
    vcs_info_msg_0_=
}
vcs-enable () {
    __enable_prompt_untracked_files=y
    add-zsh-hook precmd vcs_info
}
alias disable-vcs=vcs-disable
alias enable-vcs=vcs-enable



#### gpg and ssh ####
# gpg-agent
function launch-gpg-agent {
    case "$(uname)" in
        Darwin)
            if which pinentry-mac >/dev/null 2>&1;then
                gpg-agent --daemon --pinentry-program $(which pinentry-mac)
            else
                gpg-agent --daemon --pinentry-program $(which pinentry-tty)
            fi
            ;;
        *)
            gpg-agent --daemon
            ;;
    esac
}


# Please call this function at .zshrc.mine.
# Usage: (add-ssh-keys path/to/ssh-key-password.gpg .ssh/id_ed25519 >/dev/null 2>&1 &)
# $1: password gpg file path
# $2...: ssh key passes
function add-ssh-keys {
    launch-gpg-agent
    local passwd_path="$1"
    shift
    if tty >/dev/null 2>&1;then
        local tty=$(tty)
    fi
    local key
    local ret=0
    for key in "$@" ;do
        DISPLAY=dummy \
               SSH_ASKPASS="$HOME"/.dotfiles-lib/bin/gpg-ssh-askpass \
               PASSWORD_GPG_PATH="$passwd_path" \
               TTY="$tty" \
               ssh-add "$key" </dev/null
        ((ret |= $?))
    done

    return $ret
}


# fixing ssh socket path when screen
# see .ssh/rc too.
if [[ -n "$SSH_TTY" && "$TERM" =~ ^screen ]];then
    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
fi


function launch-ssh-agent {
    setopt local_options NO_WARN_CREATE_GLOBAL
    eval $(ssh-agent -s "$@")
}

# launch ssh-agent if not launched
export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-$HOME/.ssh/ssh_auth_sock_local}"
if [ ! -S "$SSH_AUTH_SOCK" ];then
    echo "launch ssh-agent"
    launch-ssh-agent
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock_local
fi


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


# rehash on showing prompt.
# I don't need command PATH caching because installed new commands (eg. installed by brew, apt) are not come in the completion.
function precmd_rehash {
    hash -r
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd_rehash


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
alias L='less'
alias le='less'

if [ -z "$LESSOPEN" ];then
    if which lesspipe.sh > /dev/null;then
        export LESSOPEN="|lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
    fi
fi

alias g='git'
alias gadd='git add'
alias gc='git commit -v'
alias gcame='gc --amend --no-edit'
alias gcho='git checkout'
alias gchob='git checkout -b'
alias gchop='git checkout -'  # go to previous branch
alias gpush='git push -u'
alias gps=gpush
alias gpull='git pull'
alias gpullr='git pull --rebase'
alias greset='git reset'
alias gl='git log --color --decorate --graph --branches --tags --remotes'
alias glh='git log --color --decorate --graph HEAD'
alias gd='git diff'
alias greset-hard-HEAD='git reset --hard HEAD'
alias greset-HEAD^='git reset HEAD^'

alias lsa='ls -a'
alias lsl='ls -l'
alias lsla='ls -la'
alias lsdl='ls -dl'

alias ll='ls -l'
alias lla='ls -la'
alias lld='ls -ld'

alias ssh='ssh -A'

# aliases for `pass -c`
alias passc='pass -c'
alias pasc='pass -c'

# alias of CUT command whose delimiter is Space
alias cuts='cut -d" "'

# vims
alias rawvim='vim -u NONE -N'
alias myvim='vim -u .myvimrc -N'

# homeshick
alias ho='homeshick cd'
alias hod='homeshick cd'


alias sshfs='sshfs -o transform_symlinks -o ServerAliveCountMax=10 -o ServerAliveInterval=10 -o reconnect'

case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
    cygwin*)
        alias open=cygstart
        export CYGWIN="winsymlinks"
        ;;
esac

o () {
    if [[ -z "$1" ]];then
        open .
    else
        open "$1"
    fi
}

if [ x"$TERM" = x"screen.xterm-256color" ];then
    export TERM=xterm-256color
    export DOTFILES_TERM_MULTIPLEXER=screen
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

export EDITOR='emacsclient-ac'

alias nwemacs='command emacs -nw'

function custom-emacs {
    # usage: custom-emacs custom-emacs.d [args]...
    local custom="$1"
    local custom_fullpath="$(cd "$custom" >/dev/null; pwd)"
    shift
    emacs -q --eval="(setq user-emacs-directory \"$custom_fullpath\")" -l "$custom"/init.el "$@"
}

# avoid ^S terminal locking issue
stty stop undef

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

    case "${DOTFILES_TERM_MULTIPLEXER}" in
        screen)
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

# PATH
export PATH=/mybin:~/.usr/bin:~/.local/bin:~/.cargo/bin:"$PATH"

# execute hacks for each platform
__uname=$(uname)
[ -e ~/.dotfiles-lib/hack/"$__uname".sh ] && . ~/.dotfiles-lib/hack/"$__uname".sh

# .zshrc.mine
[ -e ~/.zshrc.mine ] && . ~/.zshrc.mine
[ -e ~/.zshrc.mine.zsh ] && . ~/.zshrc.mine.zsh


if [ "$ALLOW_OVER_ENGINEERING" = y ];then
    source ~/.over-engineering/.zshrc
fi

[ -f ~/.usr/lib/z/z.sh ] && source ~/.usr/lib/z/z.sh

# set up completion
fpath=(${HOME}/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit

# for zshrc profiling
if [ "$DOTFILES_ENABLE_ZPROF" = y ];then
    if (which zprof > /dev/null) ;then
        zprof > ~/zprof.txt
        echo 'export zprof result into ~/zprof.txt'
    fi
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_ALT_C_COMMAND='find . -maxdepth 1 -type d | cut -b3-'
export FZF_CTRL_T_COMMAND='find . -maxdepth 1 | cut -b3-'
export FZF_COMPLETION_TRIGGER=@@
export FZF_DEFAULT_OPTS='--bind btab:up,tab:down,ctrl-space:toggle'
bindkey '^X^R' history-incremental-search-backward
