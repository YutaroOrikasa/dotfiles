


fpath=(~/.over-engineering/zsh/completion $fpath)

export PATH="$HOME"/.over-engineering/bin:"$PATH"

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

if [ "$(dotfiles_os_type)" = wsl ]; then
    # This wrapper is for wsl to touch git repo in win filesystem (eg. under /mnt/c).
    # This feature is enabled if DOTFILES_USE_MSYS_GIT_ON_WSL_ON_WIN_FS is set to 1.
    # Touching git repo in win filesystem by wsl git is not work well (some operations, eg. checkout, are fail),
    # so This wrapper use msys64 git if the repo is in win filesystem.
    # But msys is too slow to use comfortably.
    git() {

        if [ "${1-}" = rev-parse ]; then
            command git "$@"
            return
        fi

        # start with drive letter or // exclude //wsl.*
        # zsh and bash regex have different behavior about \ and ''.
        # use grep for portability.
        if printf "%s\n" "$(wslpath -m "$PWD")" | grep -q -E '^([A-Z]:/|//)' &&
            ! printf "%s\n" "$(wslpath -m "$PWD")" | grep -q -E '^//wsl\.'; then
            if [ -e /mnt/c/msys64/usr/bin/git.exe ] && [ "$DOTFILES_USE_MSYS_GIT_ON_WSL_ON_WIN_FS" -eq 1 ]; then
                echo 'msys git: git' "$@" >&2
                /mnt/c/msys64/usr/bin/zsh.exe -l -i -c 'cd "$OLDPWD"; git "$@"' - "$@"
            else
                command git -c core.filemode=false "$@"
            fi
        else
            command git "$@"
        fi
    }

fi


eval "$(direnv hook zsh)"

# for archlinux's command-not-found hook
[ -e /usr/share/doc/pkgfile/command-not-found.zsh ] \
    && . /usr/share/doc/pkgfile/command-not-found.zsh
