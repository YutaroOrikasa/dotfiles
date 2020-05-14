#!/bin/sh

case $(uname) in
    Darwin)
        mkdir -p ~/Library/KeyBindings
        cp -ai ~/.homesick/repos/dotfiles/mac/DefaultKeyBinding.dict ~/Library/KeyBindings/
esac
