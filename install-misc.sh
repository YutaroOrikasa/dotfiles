#!/bin/sh

case $(uname) in
    Darwin)
        mkdir -p ~/Library/KeyBindings
        ln -sf ~/.homesick/repos/dotfiles/mac/DefaultKeyBinding.dict ~/Library/KeyBindings/
esac
