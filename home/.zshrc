#public domain

# use ~/.zshenv.mine instead of ~/.zshenv
__zshenv() {
    cat <<EOF
. ~/.zshenv.mine
__ZSHENV_MINE_LOADED=1
EOF
}

if [ -z "$__ZSHENV_MINE_LOADED" ];then
    __zshenv >> ~/.zshenv
    eval "$(__zshenv)"
fi

# export DOTFILES_ENABLE_ZPROF=y for zshrc profiling
if [ "$DOTFILES_ENABLE_ZPROF" = y ];then
    zmodload zsh/zprof
fi

[ -e ~/.zshrc.mine-pre ] && . ~/.zshrc.mine-pre

export ALLOW_OVER_ENGINEERING=${ALLOW_OVER_ENGINEERING:-y}

# PATH
export PATH=/mybin:~/.usr/bin:~/.local/bin:~/.cargo/bin:"$PATH"

if [ "$(dotfiles_os_type)" = msys ];then
    export PATH='/c/HashiCorp/Vagrant/bin':"$PATH"
    export MSYS2_ARG_CONV_EXCL='*'
fi

#see man zshall for detail

### history configurations ###
setopt EXTENDED_HISTORY  # record timestamp
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS  # ignore duplicate of previous command on history.
setopt HIST_IGNORE_SPACE  # Do not record history when command line starts with a space
setopt HIST_REDUCE_BLANKS # remove duplicated spaces in command line
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

### setops ###
# see man zshoptions
setopt AUTO_CD
setopt AUTO_PUSHD  # cd -[tab] OR cd +[tab] with comp module
setopt PUSHD_MINUS  # reverse order cd -[tab]
setopt PUSHD_SILENT  # you can use "pushd" "popd" command comftably
setopt WARN_CREATE_GLOBAL  # in function
setopt INTERACTIVE_COMMENTS
setopt CORRECT  # spelling correction
setopt GLOB_DOTS  # `*` will match dot files (eg. * => .zshrc .emacs.d ...etc).

### PARAMETERS USED BY THE SHELL ###
REPORTTIME=1

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

bindkey "^X^I" _expand_alias

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[3~" delete-char

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^X^P" up-history
bindkey "^Xp" up-history
bindkey "^X^N" down-history
bindkey "^Xn" down-history

# Home/End
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

bindkey "^[p" get-line # pop line for ^[q push-line

function backward-kill-word-or-kill-region {

    # zle backward-kill-word' will appropriately set $CUTBUFFER
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

    if git status --porcelain | grep '^??' >/dev/null ;then
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

__os_type=$(dotfiles_os_type)
#### gpg and ssh ####
# gpg-agent
rm -f ~/.gnupg/gpg-agent.conf
mkdir -p ~/.gnupg
(umask 177; : >~/.gnupg/gpg-agent.conf)
{
    echo '# This file is generated by ~/.zshrc'
    echo '# If you want to restart gpg-agent daemon, do:'
    echo '#     systemctl --user restart gpg-agent.service'
    echo '# or'
    echo '#     gpgconf --kill gpg-agent; gpg-agent --daemon'

    if which pinentry-mac >/dev/null 2>&1;then
        echo "pinentry-program $(which pinentry-mac)"
    elif which pinentry-gnome3 >/dev/null 2>&1;then
        echo "pinentry-program $(which pinentry-gnome3)"
    else
        echo "pinentry-program $(which pinentry-tty)"
        echo '# 9223372036854775807 is 2**63 - 1'
        echo "max-cache-ttl 9223372036854775807"
        echo "default-cache-ttl 9223372036854775807"
    fi
} >>~/.gnupg/gpg-agent.conf
function launch-gpg-agent {
    if which systemctl >/dev/null 2>&1 && systemctl --user list-units | grep gpg-agent-ssh.socket >/dev/null 2>&1; then
        :
    else
        gpg-agent --daemon
    fi
}


# Please call this function at .zshrc.mine.
# Usage: (add-ssh-keys path/to/ssh-key-password.gpg .ssh/id_ed25519 >/dev/null 2>&1 &)
# $1: password gpg file path
# $2...: ssh key file pathes
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


# {{{ fixing ssh socket path when screen
# see .ssh/rc too.
__readlink() {
    if command -v readlink >/dev/null 2>&1; then
        readlink "$1"
    else
        echo "$1"
    fi
}

# Connect ssh auth socket via symlink ~/.ssh/ssh_auth_sock.screen and set it to $SSH_AUTH_SOCK
# because when reconnect on screen, we reuse ssh auth socket connection with same $SSH_AUTH_SOCK envvar.

__SSH_AUTH_SOCK_ORIG=$SSH_AUTH_SOCK

if [[ -n "$SSH_TTY" && "$TERM" =~ ^screen ]] || [[ "$SSH_AUTH_SOCK" =~ 'vscode-ssh-auth-sock-' ]];then
    # Prepare ~/.ssh/ssh_auth_sock.screen
    # because ~/.ssh/ssh_auth_sock will be overwritten on another one shot ssh login.
    fix_ssh_socket_link_on_screen() {
        if [[ ! -S ~/.ssh/ssh_auth_sock.screen ]]; then
            if [ ! -e ~/.ssh/ssh_auth_sock ]; then
                # This is the case ~/.ssh/ssh_auth_sock is not prepared
                # mainly when .zshrc is loaded before .ssh/rc is installed
                # (eg. first login and install dotfiles to remote server).
                ln -sf "$__SSH_AUTH_SOCK_ORIG" ~/.ssh/ssh_auth_sock.screen
            else
                ln -sf "$(__readlink ~/.ssh/ssh_auth_sock)" ~/.ssh/ssh_auth_sock.screen
            fi
        fi

        export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock.screen

        if [ -L "$SSH_AUTH_SOCK" -a ! -S "$SSH_AUTH_SOCK" ]; then
            echo 'SSH_AUTH_SOCK is dead.'
            ls -l "$SSH_AUTH_SOCK"
        fi
    }
    add-zsh-hook precmd fix_ssh_socket_link_on_screen
    fix_ssh_socket_link_on_screen
fi

# }}} fixing ssh socket path when screen


function launch-ssh-agent {
    setopt local_options NO_WARN_CREATE_GLOBAL
    eval $(ssh-agent -s "$@")
}

__create_ssh_auth_sock_for_msys() {
    rm -f ~/.ssh/ssh_auth_sock_msys_import_wsl
    (
        WSLENV=DOTFILES_SSH_AUTH_SOCK_FORWARD_FOR_MSYS:"$WSLENV" \
            DOTFILES_SSH_AUTH_SOCK_FORWARD_FOR_MSYS=1 \
            setsid \
            socat UNIX-LISTEN:"$HOME"/.ssh/ssh_auth_sock_msys_import_wsl,fork 'EXEC:wsl --cd ~ -e bash -l -c .dotfiles-lib/bin/socat-ssh-auth-sock,nofork' &
    )
    ln -sf ~/.ssh/ssh_auth_sock_msys_import_wsl ~/.ssh/ssh_auth_sock_local
}

# launch ssh-agent if not launched
export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-$HOME/.ssh/ssh_auth_sock_local}"
__is_ssh_agent_connection_broken() {
    ssh-add -l >/dev/null 2>&1
    test $? -eq 2
}
if __is_ssh_agent_connection_broken; then
    if [ "$(dotfiles_os_type)" = msys ]; then
        if command -v socat >/dev/null 2>&1; then
            __create_ssh_auth_sock_for_msys >/dev/null 2>&1
        fi
    else
        echo "launch ssh-agent" >&2
        launch-ssh-agent
        ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock_local
    fi
fi


#### misc ####

alias pd=popd


__is_inside_git_work_tree() {
    local ret=$(git rev-parse --is-inside-work-tree 2>/dev/null) || return 1
    test "$ret" = true
}

function my-accept-line {
    if [[ -n "$BUFFER" ]];then
        zle accept-line
    else
        if __is_inside_git_work_tree;then
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

# less
export LESS='-R -gj10 --LONG-PROMPT'
alias L='less'
alias le='less'

if which lesspipe.sh > /dev/null;then
    export LESSOPEN="|lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
fi

## compile .lesskey
which lesskey >/dev/null && (lesskey &)

export GIT_EDITOR='my-git-editor'

# git aliases
alias g='git'

## git add
alias gadd='git add'
alias ga='git add'

## git commit
alias gc='git commit -v'
alias gcame='gc --amend --no-edit'
alias gc-c_HEAD='gc -c HEAD'
alias gcHEAD_title='gc -e -m "$(git log HEAD^..HEAD --format=%s)"'
# Use bare git command instead of gc alias because commands will be executed by sh.
alias gcfzf_title='printf "git commit -v -m '\''%s'\'' -e" "$(git log --format=%s | fzf)" | sh'

## git checkout
alias gcho='git checkout'
alias gchob='git checkout -b'
alias gchop='git checkout -'  # go to previous branch

## git push/pull
alias gpush='git push -u'
alias gpull='git pull'
alias gpullr='git pull --rebase --autostash'
alias gpushr='gpullr && gpush'

## git reset
alias greset='git reset'
alias greset-HEAD='git reset HEAD'
alias greset-HEAD^='git reset HEAD^'
alias greset-hard='git reset --hard'
alias greset-hard-HEAD='git reset --hard HEAD'
### Before git reset, check whether working tree is dirty or not.
alias greset-hard-HEAD^='git diff --cached --quiet || (echo "Working tree is dirty. Abort."; exit 1) && git reset --hard HEAD^'

## git stash
alias gstash='git stash'
alias gstashpop='git stash pop'

## git etc
alias gd='git diff'
alias gdca='gd --cached'
alias gl='git log --color --decorate --graph'
alias glall='gl --all'
alias gla=glall
alias gshow='g show'

## git clone and open
gclone-open-code() {
    case "$1" in
        -h|--help)
            echo "usage: gclone-open-code repo [git clone option]..."
            echo "    environment: CLONE_BASE_DIR: directory path where clone into"
            return
            ;;
    esac
    local repo="$1"
    shift
    local dir=$(basename "$repo" .git)
    local clone_dir=${CLONE_BASE_DIR:-.}/$dir
    git clone --depth=1 "$repo" "$clone_dir" "$@"
    echo "open $clone_dir ($repo) using code" >&2
    code -- "$clone_dir"

}


alias lsa='ls -a'
alias lsl='ls -l'
alias lsla='ls -la'
alias lsdl='ls -dl'

alias ll='ls -la'
alias lla='ls -la'
alias llh='ls -lah'
alias lld='ls -ld'

alias ssh='ssh -A'

# aliases for pass -c`
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
alias homeshick-update='homeshick pull && homeshick link'


alias b=brew


alias sshfs='sshfs -o transform_symlinks -o ServerAliveCountMax=10 -o ServerAliveInterval=10 -o reconnect'

case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
    cygwin*)
        alias open=cygstart
        export CYGWIN="winsymlinks"
        ;;
esac

if [ x"$TERM" = x"screen.xterm-256color" ];then
    export TERM=xterm-256color
    export DOTFILES_TERM_MULTIPLEXER=screen
fi

function nohist(){
        "$@"
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

function notify_pwd_to_emacs_ansi_term () {
    print -P "\033AnSiTc %d"
}

if [ -n "$INSIDE_EMACS" ]; then
    add-zsh-hook precmd notify_pwd_to_emacs_ansi_term
    print -P "\033AnSiTu %n"
    print -P "\033AnSiTc %d"
fi


# cd tools

function mkcdir {
    mkdir "$@" && cd $_
}
alias mkcd=mkcdir

function cdll {
    cd "$@"

    # This trick delays alias expansion to runtime.
    # Normally alias is expanded on function definition time
    # so that ll will be expanded before monkey-patched
    # (~/.dotfiles-lib/hack/"$__uname".sh).
    eval "ll"
}


function e {

    wemacsclient -a "" "$@"
}


# screen window number fixing
# Adjusting that window number starts at 1.
if [ -n "$STY" ];then
    case "$WINDOW" in
        0)
            screen -X number 1
            export WINDOW=1
            ;;
        1)
            sh <<'EOF' && screen -X eval 'number 0' 'number 2'
trap 'exit 0' USR1
trap 'exit 1' USR2
screen -p 0 -X exec kill -usr1 $$
screen -p 2 -X exec kill -usr2 $$
sleep 1 &
wait
exit 2
EOF
    esac
fi

# vscode
if which code >/dev/null ;then
    export EDITOR='code-wrapper --wait --'
fi
alias C='code-wrapper --'
alias c='code-wrapper -n --'
alias co='code-wrapper -n --wait --'

# homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions/ $fpath)

# execute hacks for each platform
__uname=$(uname)
[ -e ~/.dotfiles-lib/hack/"$__uname".sh ] && . ~/.dotfiles-lib/hack/"$__uname".sh
[ -e ~/.dotfiles-lib/hack/os_type/"$__os_type".sh ] && . ~/.dotfiles-lib/hack/os_type/"$__os_type".sh

# o() definition must be after platform hack codes
# because alias is substituted on function definition and open alias is defined in a platform hack script.
o() {
    if [[ $# -eq 0 ]];then
        open .
    else
        open "$@"
    fi
}


# lazy-eval
# It is useful for lazy evaluate 'compdef'
# after 'compinit' at the end of .zshrc.
__lazy_eval=
lazy-eval() {
    __lazy_eval="$__lazy_eval""$*; "
}

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

eval "$__lazy_eval"

unset -f lazy-eval

# for zshrc profiling
if [ "$DOTFILES_ENABLE_ZPROF" = y ];then
    if (which zprof > /dev/null) ;then
        zprof > ~/zprof.txt
        echo 'export zprof result into ~/zprof.txt'
    fi
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if which bfs >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND=bfs
    # fzf's completion.zsh says:
    #   To use custom commands instead of find, override _fzf_compgen_{path,dir}
    _fzf_compgen_path() {
        # echo "$1"
        command bfs -L "$1" \
        -name .git -prune -o -name .hg -prune -o -name .svn -prune -o \( -type d -o -type f -o -type l \) \
        -a -not -path "$1" -print 2> /dev/null | sed 's@^\./@@'
    }

    _fzf_compgen_dir() {
        command bfs -L "$1" \
        -name .git -prune -o -name .hg -prune -o -name .svn -prune -o -type d \
        -a -not -path "$1" -print 2> /dev/null | sed 's@^\./@@'
    }

fi

export FZF_COMPLETION_TRIGGER=+
export FZF_DEFAULT_OPTS='--multi --bind ctrl-space:toggle,ctrl-r:toggle-sort'
bindkey '^X^R' history-incremental-search-backward


# overwriting aliases/functions
# protection for .zsh.mine loading

# undo mv
# automatic undoable mv command
# ommiting option handling for simpleness of implementation
# TODO: handle this case
#  mkdir D
#  mv_or_undo_mv a D/
#  mv_or_undo_mv a D/  # non intended behavior: mv D a
function mv_or_undo_mv() {
    if [ "$#" = 2 ] && [ ! -e "$1" ] && [ -e "$2" ];then
        echo undo mv "$1" "$2" >&2
        command mv "$2" "$1"
    else
        command mv "$@"
    fi
}

alias mv=mv_or_undo_mv
