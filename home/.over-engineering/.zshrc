


fpath=(~/.over-engineering/zsh/completion $fpath)

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
