#!/bin/sh

case $(uname) in
    Darwin)

        # DefaultKeyBinding
        mkdir -p ~/Library/KeyBindings
        ln -sf ~/.homesick/repos/dotfiles/mac/DefaultKeyBinding.dict ~/Library/KeyBindings/

        # Spectacle
        mkdir -p ~/Library/Application\ Support/Spectacle/
        ln -sf ~/.homesick/repos/dotfiles/mac/Spectacle/Shortcuts.json ~/Library/Application\ Support/Spectacle/
esac
