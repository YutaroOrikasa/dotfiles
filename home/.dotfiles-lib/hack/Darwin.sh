
function brew {
    # Change permission of zsh dir for brew's installing on
    # non privileged mode.
    sudo chown -R "$USER" /usr/local/share/zsh

    # do brew command
    command brew "$@"

    # Restore permission of zsh dir for avoiding zsh's error:
    #     zsh compinit: insecure directories, run compaudit for list.
    sudo chown -RL root /usr/local/share/zsh
}


alias ls='ls -G'
