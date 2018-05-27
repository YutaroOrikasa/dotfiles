
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

function __ask-prompt-color {
    (
        set -o NO_WARN_CREATE_GLOBAL
        subject="$1"
        name="$2"
        while :;do
            echo "select a color of $subject of prompt" >&2
            echo "0-255: 256 color, l: list sample, s: skip, n: no color, a: auto" >&2
            local AUTO_COLNUM=$(__auto_color_echo $name)
            echo -n "auto sample: " >&2
            __col256echo "$name $AUTO_COLNUM" $AUTO_COLNUM >&2
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
                        COL_NUM=$(__auto_color_echo $name)
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
