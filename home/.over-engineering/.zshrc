


fpath=(~/.over-engineering/zsh/completion $fpath)

export PATH="$HOME"/.over-engineering/bin:"$PATH"

if which code >/dev/null ;then
    export EDITOR='code-smart --wait'
fi

alias C=code-smart

function cheatsheet {
    less ~/.cheatsheet/"$1"
}


function check-homeshick-git-status {
    (
        cd ~/.homesick/repos/
        for repo in *;do
            (
                cd $repo
                if git status -s -b | grep ahead >/dev/null  ;then
                    echo "PUSH ~/.homesick/repos/$repo"
                    git status -s
                else
                    if [ -n "$(git status -s)" ];then
                        echo " ~/.homesick/repos/$repo"
                        git status -s
                    fi
                fi

            )
        done

    )
}


eval "$(direnv hook zsh)"

# for archlinux's command-not-found hook
[ -e /usr/share/doc/pkgfile/command-not-found.zsh ] \
    && . /usr/share/doc/pkgfile/command-not-found.zsh
