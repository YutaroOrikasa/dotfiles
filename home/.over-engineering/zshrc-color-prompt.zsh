
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

function __auto_color_echo {
    local HASH=$(printf %s $1 | $__md5)
    # using first 2 chars for 256 color number
    echo $(( 0x$(echo $HASH | dd bs=1 count=2 2>/dev/null)))
    
}

# $1: subject (eg. username, hostname, etc)
# $2: string to print in prompt with color
# stdout: selected color number or string "default"
# stdin, stderr: used for interactive to a console user
# return: 1 if the user selected skip, else 0
function __ask-prompt-color {
    (
        function msg {
            echo "$@" >&2
        }

        # Here in subshell. You don't have to use `local'
        # to define local variable.
        set -o NO_WARN_CREATE_GLOBAL
        subject="$1"
        name="$2"
        auto_colnum=$(__auto_color_echo $name)
        msg "select a color of $subject of prompt"
        msg "auto sample (color number = $auto_colnum): "
        __col256echo "$name" $auto_colnum >&2
        msg -n "OK? [y/n]: "
        read -r input
        if [ "$input" = y ];then
            echo $auto_colnum
            return
        fi
        while :;do
            msg "select a color of $subject of prompt"
            msg

            msg "0-255: 256 colors"
            msg "l: list samples"
            msg "s: skip (ask on next launch)"
            msg "d: default color of terminal"
            msg "a: auto"         
            msg

            msg -n "[0-255/l/s/d/a]: "
            read -r input
            if [[ "$input" =~ '^[0-9]+$' ]] && (( 0<=input && input <= 255 ));then
                COL_NUM=$input
            else
                case "$input" in
                    l)
                        for i in $(seq 0 255);do
                            __col256echo "$name $i" $i >&2
                            msg
                        done
                        continue
                        ;;
                    s)
                        return 1
                        ;;
                    a)
                        COL_NUM=$(__auto_color_echo $name)
                        msg "auto color number = $COL_NUM"
                        ;;
                    d)
                        COL_NUM=
                        ;;
                    *)
                        msg "bad input $input"
                        continue
                        ;;
                esac
            fi
            __col256echo "$name $COL_NUM" $COL_NUM >&2
            msg -n "OK? [y/n]: "
            read -r input
            if [ "$input" = y ];then
                if [ -z "$COL_NUM" ];then
                    echo "default"
                fi
                echo $COL_NUM
                return 0
            fi
        done
    )
}

function __setup-prompt-color {
    local col_num_var_name="$1"
    local subject="$2"
    local name="$3"

    local col_num=$(eval echo "$col_num_var_name")
    if [ -z "$col_num" ];then
        col_num=$(__ask-prompt-color "$subject" "$name") \
            || echo "skip setting $subject color"

        echo "save $subject color $col_num_var_name to .zshrc.mine-pre"
        echo >> ~/.zshrc.mine-pre
        echo "$col_num_var_name"="$col_num" >> ~/.zshrc.mine-pre
    fi
}

__setup-prompt-color USER_COL_NUM "user name" $USER
__setup-prompt-color HOST_COL_NUM "host name" $HOST


function __USER_COL_ESC_SEQ {
    # check USER_COL_NUM == no for backward compatibility
    if [[ -n "$USER_COL_NUM" && ! "$USER_COL_NUM" =~ "no|default" ]];then
        echo "%{\e[38;5;${USER_COL_NUM}m%}"
    fi
}

function __HOST_COL_ESC_SEQ {
    if [[ -n "$HOST_COL_NUM" && ! "$HOST_COL_NUM" =~ "no|default" ]];then
        echo "%{\e[38;5;${HOST_COL_NUM}m%}"
    fi
}

PROMPT_USERNAME=$(echo -e '$(__USER_COL_ESC_SEQ)%n%{\e[0m%}')
PROMPT_HOSTNAME=$(echo -e '$(__HOST_COL_ESC_SEQ)%m%{\e[0m%}')
