#!/bin/bash
set -v
cat vscode_plugins | xargs -n 1 code --install-extension
