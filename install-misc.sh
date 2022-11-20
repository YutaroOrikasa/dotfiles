#!/bin/sh

case $(uname) in
    Darwin)

        # DefaultKeyBinding
        mkdir -p ~/Library/KeyBindings
        ln -sf ~/.homesick/repos/dotfiles/mac/DefaultKeyBinding.dict ~/Library/KeyBindings/
esac
